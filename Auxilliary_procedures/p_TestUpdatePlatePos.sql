use Auxilliary
go

SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO
-- Expects sample info in file in path E:\Edvards_share\Proc_refs\FileToSelect\Data.txt
-- with columns
-- Plate, position, old-sample-name, new-sample-name
alter procedure p_TestUpdatePlatePos(
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

select * from @parsed_sample_location

select top(10) * from gtdb2.dbo.sample
return

select s.identifier 
from @parsed_sample_location psl
inner join gtdb2.dbo.plate p on p.identifier = psl.plate
inner join gtdb2.dbo.sample s on s.identifier = psl.sample_name
inner join gtdb2.dbo.tube_aliquot ta on ta.plate_id = p.plate_id and 
	ta.position_x = psl.pos_x and
	ta.position_y = psl.pos_y

return

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
