use GTDB2_devel
go
set ansi_nulls off
go
set quoted_identifier off
go
create procedure p_GetMarkerAssayMapByIdentifier(
	@identifier varchar(255)
)
as 
begin
set nocount on 
	select
		marker_assay_map_id as id,
		identifier,
		project_id,
		created_date,
		is_open
	from marker_assay_map
	where identifier = @identifier

set nocount off
end
