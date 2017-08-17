use Auxilliary
go

SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO
-- Expects add measurement copy file in path E:\Edvards_share\Proc_refs\FileToSelect\Data.txt
-- with columns
-- Plate, position, value
-- 
-- Undo when user have updated concentration_customer with 'Add measurements' in a wrong way
-- This script only works when user has updated original samples
--
-- NOTE: The row_pick and update_history values shown in validation have to be reviewed carefully.
-- If the user want to undo an old add measurement update, and another user has updated the same 
-- field for any listed sample
-- in between, this procedure will undo in a wrong way.
--
-- Validation mode:
-- Show sample history together with row number, each group is a sample and the latest update 
-- has the lowest row number
-- Show for each sample the row number that is going to be used to revert the value



alter procedure p_UndoConcCustomer(
	@validate varchar(50) = 'yes'
)
as 
begin

declare @tmp table(
	plate varchar(255),
	position varchar(255),
	value varchar(255)) 

insert into @tmp
exec Auxilliary.dbo.p_FileToSelect 3

declare @update_history table(
sample varchar(255),
conc_customer float,
change_date datetime,
change_person varchar(255),
rn int)

insert into @update_history
(sample, conc_customer, change_date, change_person, rn)
select s.identifier, sh.concentration_customer, sh.changed_date, a.name,
	ROW_NUMBER() over (partition by s.identifier order by sh.changed_date desc)
from @tmp t
inner join gtdb2.dbo.plate p on p.identifier = t.plate
inner join gtdb2.dbo.sample s on s.plate_id = p.plate_id and 
	s.pos_x = Auxilliary.dbo.fn_ParsePosX(t.position) and
	s.pos_y = Auxilliary.dbo.fn_ParsePosY(t.position)
inner join gtdb2.dbo.sample_history sh on s.sample_id = sh.sample_id
inner join gtdb2.dbo.authority a on sh.changed_authority_id = a.authority_id
order by s.identifier, sh.changed_date

declare @update_history_ext table(
sample varchar(255),
conc_customer float,
change_date datetime,
change_person varchar(255),
rn int,
differ_from_last bit)

insert into @update_history_ext
(sample, conc_customer, change_date, change_person, rn)
select sample, conc_customer, change_date, change_person, rn
from @update_history

update uhe2 set
	differ_from_last = case when uhe1.conc_customer = uhe2.conc_customer then 0 else 1 end
from @update_history_ext uhe1 
inner join @update_history_ext uhe2 on uhe1.sample = uhe2.sample
where uhe1.rn = 1


declare @row_pick table(
sample varchar(255),
row_pick int)

insert into @row_pick
(sample, row_pick)
select sample, min(rn)
from @update_history_ext
where differ_from_last = 1
group by sample


if @validate = 'yes' begin
	select * from @update_history
	select * from @row_pick
	return
end

update s set
	concentration_customer = uhe.conc_customer
from @update_history_ext uhe
inner join @row_pick rp on uhe.sample = rp.sample and
	uhe.rn = rp.row_pick
inner join GTDB2.dbo.sample s on s.identifier = uhe.sample

SET NOCOUNT off
end
go
