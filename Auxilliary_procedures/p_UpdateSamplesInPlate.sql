use Auxilliary
go

SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO
-- Expects sample info in file in path E:\Edvards_share\Proc_refs\FileToSelect\Data.txt
-- with columns
-- Plate, position, old-sample-name, new-sample-name
--
-- There is a check that all samples exist in db, if not, there will be a 
-- sample list with external names to paste into a sample 
-- submission form and the procedure is stopped


alter procedure p_UpdateSamplesInPlate(
	@validate varchar(50) = 'yes'
)
as 
begin

declare @tmp table(
	plate varchar(255),
	position varchar(255),
	old_sample varchar(255),
	new_sample varchar(255)) 

insert into @tmp
exec Auxilliary.dbo.p_FileToSelect 4

if @validate = 'yes' begin
	select * from @tmp
	return
end

-- Check if all desired samples are defined in db
declare @staging table(staged_name varchar(255))
if exists(select t.new_sample from @tmp t where t.new_sample not in (
select s.identifier 
from @tmp t
inner join gtdb2.dbo.sample s on t.new_sample = s.identifier)) begin
	select 'Insert next table result into a sample submission form!'

	insert into @staging
	(staged_name)
	select substring(t.new_sample, patindex('%[_]%', t.new_sample) + 1, len(t.new_sample))
	from @tmp t where t.new_sample not in (
		select s.identifier 
		from @tmp t
		inner join gtdb2.dbo.sample s on t.new_sample = s.identifier)

	select SUBSTRING(staged_name, 1, charindex('.', staged_name) - 1) as external_sample_name
	from @staging
	return
end

-- All samples in db, go on with db update
declare @parsed_sample_location table(
plate varchar(255),
pos_x int,
pos_y int,
sample_name varchar(255))

insert into @parsed_sample_location
(plate, pos_y, pos_x, sample_name)
select 
	plate, 
	ascii(substring(position, 1,1)) - ascii('A') + 1 as pos_y, 
	cast(SUBSTRING(position, 2,2) as int) as pos_x,
	new_sample 
from @tmp

update ta set
	sample_id = s.sample_id
from @parsed_sample_location psl
inner join gtdb2.dbo.plate p on p.identifier = psl.plate
inner join gtdb2.dbo.sample s on s.identifier = psl.sample_name
inner join gtdb2.dbo.tube_aliquot ta on ta.plate_id = p.plate_id and 
	ta.position_x = psl.pos_x and
	ta.position_y = psl.pos_y


SET NOCOUNT off
end
go
