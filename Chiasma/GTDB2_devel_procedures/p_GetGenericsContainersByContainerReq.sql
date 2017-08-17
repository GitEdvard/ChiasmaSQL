USE [GTDB2_devel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Searches all active plates and tubes for the given container name
-- Makes a reqursive search
create PROCEDURE [dbo].[p_GetGenericsContainersByContainerReq](
	@container_name varchar(255))

AS
BEGIN
SET NOCOUNT ON

declare @container table(
	id int,
	identifier varchar(255),
	matching bit default 0
)
insert into @container
(id, identifier)
select container_id, identifier
from container

declare cont_cursor cursor
	for select id from @container
declare @container_id int
declare @container_id_work int
declare @continue bit
declare @search varchar(255)

open cont_cursor
fetch next from cont_cursor
	into @container_id


while @@FETCH_STATUS = 0
begin
	
	-- Loopar genom varje f?rvaringsplats i systemet (frys, box, l?da, rum, etc)
	-- F?r varje s?dan, skanna igenom varje ?verordnad f?rvaringsplats, och 
	-- leta efter s?kordet (ex. frys 1)
	-- Exempel, Pooler_i_l?da28 har s?kv?g BMC/ 023b(k?llare)/ Frys 43/ Back #9/ Pooler_i_l?da28
	-- och kommer f? tr?ff p? 'Frys 43'
	set @continue = 1
	set @container_id_work = @container_id

	while @continue = 1
	begin
		if exists(
			select parent.container_id
			from contents ct
			inner join container parent on parent.container_id = ct.parent_container_id
			where ct.child_container_id = @container_id_work
		)
		begin 
			select @container_id_work = parent.container_id
			from contents ct
			inner join container parent on parent.container_id = ct.parent_container_id
			where ct.child_container_id = @container_id_work
			if exists(
				select * 
				from container c
				where (c.container_id = @container_id_work and
					c.identifier = @container_name) or
					(c.container_id = @container_id and
						c.identifier = @container_name)
				)
			begin
				set @continue = 0
				update @container set
					matching = 1
				where id = @container_id
			end
		end
		else
		begin 
			set @continue = 0
		end
	end


	fetch next from cont_cursor
		into @container_id
end

close cont_cursor
deallocate cont_cursor

select p.identifier, 'plate' as type
from plate p
inner join contents ct on p.plate_id = ct.child_container_id
where ct.parent_container_id in
(select c.id from @container c where c.matching = 1)
and p.status = 'active'
union
select t.identifier, 'tube' as type
from tube t
inner join contents ct on t.tube_id = ct.child_container_id
where ct.parent_container_id in
(select c.id from @container c where c.matching = 1)
and t.status = 'active'

SET NOCOUNT OFF
END
