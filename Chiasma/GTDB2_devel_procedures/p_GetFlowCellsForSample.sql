USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetFlowCellsForSample]    Script Date: 11/20/2009 15:56:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_GetFlowCellsForSample](@sample_id INTEGER)

AS
BEGIN
SET NOCOUNT ON


SELECT
	flow_cell.flow_cell_id AS id,
	flow_cell.bead_chip_type_id,
	flow_cell.identifier,
	flow_cell.status AS status,
	flow_cell.comment,
	barcode.code as barcode
FROM flow_cell
INNER JOIN flow_cell_well fcw on fcw.flow_cell_id = flow_cell.flow_cell_id
LEFT OUTER JOIN barcode ON barcode.identifiable_id = flow_cell.flow_cell_id AND barcode.kind = 'CONTAINER'
inner join tube_aliquot ta on (fcw.source_container_id = isnull(ta.plate_id, -1) and 
fcw.source_container_position_x = isnull(ta.position_x, -1) and 
fcw.source_container_position_y = isnull(ta.position_y, -1)) or 
(fcw.source_container_id = isnull(ta.tube_id, -1))
where ta.sample_id = @sample_id
union
SELECT
	flow_cell.flow_cell_id AS id,
	flow_cell.bead_chip_type_id,
	flow_cell.identifier,
	flow_cell.status AS status,
	flow_cell.comment,
	barcode.code as barcode
FROM flow_cell
INNER JOIN flow_cell_well fcw on fcw.flow_cell_id = flow_cell.flow_cell_id
LEFT OUTER JOIN barcode ON barcode.identifiable_id = flow_cell.flow_cell_id AND barcode.kind = 'CONTAINER'
inner join aliquot a on fcw.source_container_id = isnull(a.plate_id, -1) and 
fcw.source_container_position_x = isnull(a.position_x, -1) and 
fcw.source_container_position_y = isnull(a.position_y, -1)
where a.sample_id = @sample_id

SET NOCOUNT OFF
END
