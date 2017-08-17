use GTDB2_devel
go
set ansi_nulls off
go
set quoted_identifier off
go
create procedure p_GetMarkerAssayLinks(
	@marker_assay_map_id int
)
as 
begin
set nocount on 
	select 
		marker_assay_link_id,
		marker_assay_map_id,
		marker_id,
		assay_id
	from marker_assay_link
	where marker_assay_map_id = @marker_assay_map_id

set nocount off
end
