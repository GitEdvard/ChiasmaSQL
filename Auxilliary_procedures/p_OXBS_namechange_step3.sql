use Auxilliary
go

SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO
-- Expects a tube list in file in path E:\Edvards_share\Proc_refs\FileToSelect\Data.txt


alter procedure p_OXBS_namechange_step3(
	@info bit = 1, @validate bit = 0, @run bit = 0
)
as 
begin

if @info = 1 begin
	print 'Step 3: 
	Rename tubes intended to hold OX and BS variants. Change sample reference for these tubes, 
	so that they refer to the corresponding OX or BS sample.

Required preparation:
	OX and BS samples created according to step 2

DB updates at @run = 1
	GTDB2:	tube.identifier,
			tube_aliquot.sample_id
	Auxilliary: None

Input: 
	A list of tubes that is already saved in step 1.
	Step 1 must have been executed with @run = 1 before this script!

Output: 
	A list showing the name change of tubes, and the new sample reference
		tube name before, tube name after, new referenced sample'
	return
end

declare @tmp table(
	tube_name varchar(255)
	) 

if exists(select * from oxbs_namechange_tube_name
			where not CONVERT(date, change_date) = CONVERT(date, getdate()))
begin
	raiserror('Step 1 has not been executed! Date signature of temp tube table does not match!', 15, 1)
	return
end

insert into @tmp
(tube_name)
select tube_name from oxbs_namechange_tube_name

if @validate = 1 begin
	select * from @tmp
end


-- RENAME TUBES
declare @tubes table(
	tube_name varchar(255),
	tube_id int,
	rn int,
	dot_index int,
	dot_index_reverse int,
	tube_new_name varchar(255),
	new_sample_id int,
	old_sample_identifier varchar(255),
	new_sample_identifier varchar(255)
)

insert into @tubes
(tube_name, tube_id, rn, dot_index, dot_index_reverse)
select 
	t.identifier,	
	t.tube_id,
	ROW_NUMBER() over (partition by ta.sample_id order by t.identifier),
	PATINDEX("%.%", t.identifier ) - 1,
	PATINDEX("%.%", REVERSE( t.identifier ))
from @tmp tt
inner join GTDB2.dbo.tube t on t.identifier = tt.tube_name
inner join GTDB2.dbo.tube_aliquot ta on ta.tube_id = t.tube_id

-- Set OX tube names
update tt set
	tube_new_name = left(tt.tube_name, tt.dot_index) + '_OX' + 
						right(tt.tube_name, len(tt.tube_name) - tt.dot_index)
from @tubes tt
where tt.rn = 1

-- Set BS tube names
update tt set
	tube_new_name = left(tt.tube_name, tt.dot_index) + '_BS' + 
						right(tt.tube_name, len(tt.tube_name) - tt.dot_index)
from @tubes tt
where tt.rn = 2

-- CHANGE SAMPLE REFERENCES FOR TUBES
-- First find the new sample ids that should be linked up with the tubes

-- Extract namebase of input samples, strip of the version number
declare @sample_match table(
	sample_orig_name varchar(255),
	dot_index_reverse int,
	sample_stem_name varchar(255)
)

insert into @sample_match
(sample_orig_name)
select sample_name from oxbs_tube_sample_couple

update sm
	set dot_index_reverse = PATINDEX("%.%", reverse( sm.sample_orig_name)) - 1
from @sample_match sm

update sm
	set sample_stem_name = SUBSTRING(sm.sample_orig_name, 0, len(sm.sample_orig_name) - sm.dot_index_reverse)
from @sample_match sm

-- Find sample references to OX samples, not existing samples
update tt set
	new_sample_id = s2.sample_id,
	new_sample_identifier = s2.identifier,
	old_sample_identifier = s1.identifier
from @tubes tt
inner join GTDB2.dbo.tube_aliquot ta on ta.tube_id = tt.tube_id
inner join GTDB2.dbo.sample s1 on ta.sample_id = s1.sample_id
inner join oxbs_tube_sample_couple tsc on tsc.tube_name = tt.tube_name
inner join @sample_match sm on sm.sample_orig_name = tsc.sample_name
inner join GTDB2.dbo.sample s2 on s2.individual_id = s1.individual_id and
	s2.identifier like sm.sample_stem_name + '%OX.v1%'
where tt.rn = 1

-- Find sample references for existing OX samples
update tt set
	new_sample_id = s2.sample_id,
	new_sample_identifier = s2.identifier,
	old_sample_identifier = s1.identifier
from @tubes tt
inner join GTDB2.dbo.tube_aliquot ta on ta.tube_id = tt.tube_id
inner join GTDB2.dbo.sample s1 on ta.sample_id = s1.sample_id
inner join oxbs_tube_sample_couple tsc on tsc.tube_name = tt.tube_name
inner join dbo.oxbs_namechange_existing_oxbs eo on eo.ord_sample_id = s1.sample_id and eo.oxbs_type = 'ox'
inner join GTDB2.dbo.sample s2 on s2.sample_id = eo.oxbs_sample_id
where tt.rn = 1


-- Find sample references to BS samples, not existing samples
update tt set
	new_sample_id = s2.sample_id,
	new_sample_identifier = s2.identifier,
	old_sample_identifier = s1.identifier
from @tubes tt
inner join GTDB2.dbo.tube_aliquot ta on ta.tube_id = tt.tube_id
inner join GTDB2.dbo.sample s1 on ta.sample_id = s1.sample_id
inner join oxbs_tube_sample_couple tsc on tsc.tube_name = tt.tube_name
inner join @sample_match sm on sm.sample_orig_name = tsc.sample_name
inner join GTDB2.dbo.sample s2 on s2.individual_id = s1.individual_id and
	s2.identifier like sm.sample_stem_name + '%BS.v1%'
where tt.rn = 2

-- Find sample references for existing BS samples
update tt set
	new_sample_id = s2.sample_id,
	new_sample_identifier = s2.identifier,
	old_sample_identifier = s1.identifier
from @tubes tt
inner join GTDB2.dbo.tube_aliquot ta on ta.tube_id = tt.tube_id
inner join GTDB2.dbo.sample s1 on ta.sample_id = s1.sample_id
inner join oxbs_tube_sample_couple tsc on tsc.tube_name = tt.tube_name
inner join dbo.oxbs_namechange_existing_oxbs eo on eo.ord_sample_id = s1.sample_id and eo.oxbs_type = 'bs'
inner join GTDB2.dbo.sample s2 on s2.sample_id = eo.oxbs_sample_id
where tt.rn = 2


if @validate = 1 begin
	select tube_name as old_tube_name, tube_new_name as new_tube_name,
		old_sample_identifier, new_sample_identifier
	from @tubes
	return
end

if @run = 1 begin
	-- Update tube names
	update t set
		identifier = tt.tube_new_name
	from @tubes tt 
	inner join GTDB2.dbo.tube t on t.tube_id = tt.tube_id

	-- Update sample references for tubes
	update ta set 
		sample_id = tt.new_sample_id
	from @tubes tt
	inner join GTDB2.dbo.tube_aliquot ta on ta.tube_id = tt.tube_id
end

SET NOCOUNT off
end
go
