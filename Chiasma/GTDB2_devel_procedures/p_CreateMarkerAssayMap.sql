use GTDB2_devel

go
set ansi_nulls off
go
set quoted_identifier off
go
create procedure p_CreateMarkerAssayMap(
	@identifier varchar(255),
	@project_id int
)
as 
begin
set nocount on 
	insert into marker_assay_map
	(identifier, project_id)
	values
	(@identifier, @project_id)

select 
	m.marker_assay_map_id as id, 
	m.created_date, 
	m.identifier, 
	m.is_open, 
	m.project_id
from marker_assay_map m 
where identifier = @identifier

set nocount off
end
