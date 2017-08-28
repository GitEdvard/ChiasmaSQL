use Auxilliary
go

SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO
-- Expects a tube list in file in path E:\Edvards_share\Proc_refs\FileToSelect\Data.txt


alter procedure p_OXBS_namechange_step1(
	@info bit = 1, @validate bit = 0, @run bit = 0, @use_existing_samples bit = 1
)
as 
begin

if @info = 1 begin
	print 'Step 1: 
	Outputs a list of individual - sample pairs to be inserted into
	a sample submission form and imported into Chiasma. 

Note: 
	That the sample series is right at the sample import. Especially when the list is from more than
	one sample series! When in the import sample wizard in Chiamsa, copy the created samples into 
	clipboard and paste it into e.g. excel for later use. 

	This script have to be run with @run = 1 before step 2!!

	If a corresponding OX or BS sample already exist for a listed tube, the output of
	this script will be adjusted.

Required preparation:
	Create tube pairs for each sample which is to be turned into OX and BS versions. This is 
	accomplished by ordinary dilution in Chiasma.

DB updates at @run = 1
	GTDB2: None
	Auxilliary: ''working tables'' used in later steps
				oxbs_namechange_tube_name
				oxbs_namechange_existing_oxbs

Input: 
	A list of tubes described above, which should be turned into OX and BS samples. 
	The tubes should be in duplicate for each individual. Example:
			
			NC_1.v1_500ng_161020.v1
			NC_1.v1_500ng_161020.v2
			NC_2.v1_500ng_161020.v1
			...

	This list should be pasted into 
	E:\Edvards_share\Proc_refs\FileToSelect\Data.txt on server (shared folder)

Output: 
	A list of corresponding pairs of
		individual external name, sample external name'
	return
end

declare @tmp table(
	tube_name varchar(255)
	) 

insert into @tmp
exec Auxilliary.dbo.p_FileToSelect

delete from @tmp where tube_name = null

if @validate = 1 begin
	select * from @tmp
end

declare @ind_sample_pairs table(
	ind_ext_name varchar(255),
	sample_ext_name varchar(255),
	rn int
)

-- Fetch already existing OX or BS samples for selected tube set
declare @existing_oxbs table(
	myid int identity(1,1),
	ord_sample_id int,
	oxbs_sample_id int,
	sample_name_ord varchar(255),
	sample_name_oxbs varchar(255),
	rn int,
	oxbs_type varchar(10)
)

if @use_existing_samples = 1
begin
	insert into @existing_oxbs
	(ord_sample_id, sample_name_ord, sample_name_oxbs, oxbs_sample_id)
	select distinct s1.sample_id, s1.identifier, s2.identifier, s2.sample_id
	from @tmp tt
	inner join GTDB2.dbo.tube t on tt.tube_name = t.identifier
	inner join GTDB2.dbo.tube_aliquot ta on ta.tube_id = t.tube_id
	inner join GTDB2.dbo.sample s1 on s1.sample_id = ta.sample_id
	inner join GTDB2.dbo.sample s2 on s2.individual_id = s1.individual_id and
		(s2.identifier like '%OX.v1%' or s2.identifier like '%BS.v1%')
end

update eo set
	oxbs_type = case 
					when eo.sample_name_oxbs like '%OX%' then 'OX'
					when eo.sample_name_oxbs like '%BS%' then 'BS'
				end
from @existing_oxbs eo

-- Assign row numer in @existing_oxbs
-- doesn't work directly due to 'distinct'
declare @tmp_rn_assign table(
	id int,
	rn int)

insert into @tmp_rn_assign
(id, rn)
select myid, ROW_NUMBER() over (partition by ord_sample_id order by sample_name_ord)
from @existing_oxbs

update eo set
	rn = tra.rn
from @existing_oxbs eo
inner join @tmp_rn_assign tra on eo.myid = tra.id

if @validate = 1 begin
	select sample_name_ord, sample_name_oxbs as existing_OXBS_sample, rn
	from @existing_oxbs
end

-- Fetch samples for each tube
-- Retrieve a list of individual -- sample pairs
insert into @ind_sample_pairs
(ind_ext_name, sample_ext_name, rn)
select i.external_name as individual_external_name, s.external_name as sample_external_name,
ROW_NUMBER() over (partition by i.external_name order by i.external_name)
from @tmp tt
inner join GTDB2.dbo.tube t on t.identifier = tt.tube_name
inner join GTDB2.dbo.tube_aliquot ta on ta.tube_id = t.tube_id
inner join GTDB2.dbo.sample s on s.sample_id = ta.sample_id
inner join GTDB2.dbo.individual i on i.individual_id = s.individual_id

delete from isp
from @existing_oxbs eo
inner join GTDB2.dbo.sample s on s.sample_id = eo.ord_sample_id
inner join @ind_sample_pairs isp on s.external_name = isp.sample_ext_name and
	isp.rn = eo.rn

if @validate = 1 begin
	select * from @ind_sample_pairs
	return
end

if @run = 1 begin

	delete from oxbs_namechange_tube_name
	insert into oxbs_namechange_tube_name
	(tube_name, change_date)
	select tube_name, getdate() from @tmp

	delete from oxbs_namechange_existing_oxbs
	insert into oxbs_namechange_existing_oxbs
	(ord_sample_id, oxbs_sample_id, oxbs_type)
	select ord_sample_id, oxbs_sample_id, oxbs_type
	from @existing_oxbs

	select 'Paste this list into a sample submission form and import into Chiasma'
end

select ind_ext_name, sample_ext_name from @ind_sample_pairs


SET NOCOUNT off
end
go
