use GTDB2_devel
go
set ansi_nulls off
go
set quoted_identifier off
go
create procedure p_CreateMarkerAssayLink(
	@marker_assay_map_id int, 
	@marker_id int,
	@assay_id int
)
as 
begin
set nocount on 
	insert into marker_assay_link
	(marker_assay_map_id, marker_id, assay_id)
	values
	(@marker_assay_map_id, @marker_id, @assay_id)

set nocount off
end
