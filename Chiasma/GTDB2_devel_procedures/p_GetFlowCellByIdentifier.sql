USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetFlowCellByIdentifier]    Script Date: 11/20/2009 15:58:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[p_GetFlowCellByIdentifier](@identifier VARCHAR(255))

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
LEFT OUTER JOIN barcode ON barcode.identifiable_id = flow_cell.flow_cell_id AND barcode.kind = 'CONTAINER'
WHERE flow_cell.identifier = @identifier

SET NOCOUNT OFF
END
