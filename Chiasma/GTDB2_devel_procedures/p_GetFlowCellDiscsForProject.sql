USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetFlowCellDiscsForProject]    Script Date: 11/20/2009 15:58:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_GetFlowCellDiscsForProject](@id INTEGER)

AS
BEGIN
SET NOCOUNT ON

SELECT
fcd.flow_cell_disc_id as id,
fcd.identifier,
fcd.comment,
barcode.code as barcode
FROM flow_cell_disc fcd
LEFT OUTER JOIN barcode 
ON (barcode.identifiable_id = fcd.flow_cell_disc_id AND barcode.kind = 'FLOW_CELL_DISC')
WHERE fcd.flow_cell_disc_id IN
(SELECT flow_cell_disc_id FROM flow_cell_disc_project_link WHERE project_id = @id)
AND fcd.status != 'Disposed'

SET NOCOUNT OFF
END
