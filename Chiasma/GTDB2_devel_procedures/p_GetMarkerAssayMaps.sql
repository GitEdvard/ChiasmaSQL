use GTDB2_devel
go
set ansi_nulls off
go
set quoted_identifier off
go
create procedure p_GetMarkerAssayMaps(
	@is_open bit,
	@project_id int
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
	where (is_open = 1 or is_open = @is_open) and
		(@project_id = -1 or project_id = @project_id)

set nocount off
end
