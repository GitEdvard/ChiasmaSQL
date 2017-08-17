use GTDB2_devel
go
set ansi_nulls off
go
set quoted_identifier off
go
create procedure p_UpdateMarkerAssayMap(
	@id int,
	@is_open bit
)
as 
begin
set nocount on 
	update mam set
		is_open = @is_open
	from marker_assay_map mam
	where mam.marker_assay_map_id = @id

set nocount off
end
