use Auxilliary
go

SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO
-- Expects a tube list in file in path E:\Edvards_share\Proc_refs\FileToSelect\Data.txt


alter procedure p_OXBS_namechange_step2(
	@info bit = 1, @validate bit = 0, @run bit = 0
)
as 
begin

if @info = 1 begin
	print 'Step 2: 
	Rename newly created samples into OX and BS variants. 

Required preparation:
	Samples dedicated to OX BS namechange have been created in Chiasma, according to step 1. 

DB updates at @run = 1
	GTDB2: sample.identifier
	Auxilliary: oxbs_tube_sample_couple

Input: 
	A list of tube-sample couples (names). The samples are to be renamed into OX and BS variants. 
	There should be two new samples refering to each individual. The first sample in each pair is 
	renamed with OX added in its name, and the second is renamed with BS in its name. 

	It is a different procedure whether a corresponding OX and BS sample already exists (CEP samples!)

	OX and BS samples does not already exists for a sample:
	Add the newly added samples that are to be renamed into the list.

	OX and BS samples already exists that can be reused:
	Add the currently referensed sample in the tube.

	Example:
	CEP_C1.v10_500ng.v1	CEP_C1.v10
	CEP_C1.v10_500ng.v2	CEP_C1.v10
	NC_1.v1_500ng.v1	NC_1.v2
	NC_1.v1_500ng.v2	NC_1.v3
	NC_2.v1_500ng.v1	NC_2.v2
	NC_2.v1_500ng.v2	NC_2.v3

	This list should be pasted into 
	E:\Edvards_share\Proc_refs\FileToSelect\Data.txt on server (shared folder)

Output: 
	A list showing the name change
		sample name before, sample name after'
	return
end

if exists(select * from oxbs_namechange_tube_name
			where not CONVERT(date, change_date) = CONVERT(date, getdate()))
begin
	raiserror('Step 1 has not been executed! Date signature of temp tube table does not match!', 15, 1)
	return
end


declare @tmp table(
	tube_name varchar(255),
	sample_name varchar(255)
) 

insert into @tmp
exec Auxilliary.dbo.p_FileToSelect 2


if @validate = 1 begin
	select * from @tmp
end

-- Partition samples over individuals with row numbers 1 & 2 within each partition
-- Retrieve the index of last occasion of dot in sample name
declare @samples_staging table(
	sample_name varchar(255),
	dot_index int,
	dot_index_reverse int,
	name_stem varchar(255)
)

-- exclude samples that are found in the existing oxbs table
insert into @samples_staging
(sample_name, dot_index, dot_index_reverse)
select distinct
	s.identifier,	
	LEN(s.identifier) - PATINDEX("%.%", REVERSE( s.identifier )),
	PATINDEX("%.%", REVERSE( s.identifier ))
from @tmp tt
inner join GTDB2.dbo.sample s on s.identifier = tt.sample_name
left outer join dbo.oxbs_namechange_existing_oxbs eo on eo.ord_sample_id = s.sample_id
where eo.oxbs_sample_id is null

update s set
	s.name_stem = SUBSTRING( s.sample_name, 1, s.dot_index)
from @samples_staging s

declare @samples table(
	sample_name varchar(255),
	sample_id int,
	rn int,
	dot_index int,
	sample_new_name varchar(255)
)


insert into @samples
(sample_name, sample_id, dot_index, rn)
select 
	s.identifier,	
	s.sample_id,
	st.dot_index,
	ROW_NUMBER() over (partition by st.name_stem order by s.identifier)
from @tmp tt
inner join GTDB2.dbo.sample s on s.identifier = tt.sample_name
inner join @samples_staging st on s.identifier = st.sample_name


-- Set OX samples names
update ts set
	sample_new_name = left(ts.sample_name, ts.dot_index) + '_OX.v1'
from @samples ts
where ts.rn = 1

-- Set BS samples names
update ts set
	sample_new_name = left(ts.sample_name, ts.dot_index) + '_BS.v1'
from @samples ts
where ts.rn = 2

-- delete entries in samples table already existing oxbs samples
delete from ts
from @samples ts
inner join GTDB2.dbo.sample s on ts.sample_new_name = s.identifier

if @validate = 1 begin
	select sample_name as old_sample_name, sample_new_name as new_sample_name
	from @samples
	return
end


if @run = 1 begin
	update s set
		identifier = ts.sample_new_name
	from @samples ts
	inner join GTDB2.dbo.sample s on s.identifier = ts.sample_name
	select sample_name as old_name, sample_new_name as new_name from @samples

	delete from oxbs_tube_sample_couple
	insert into oxbs_tube_sample_couple
	(tube_name, sample_name)
	select tube_name, sample_name from @tmp
end


SET NOCOUNT off
end
go
