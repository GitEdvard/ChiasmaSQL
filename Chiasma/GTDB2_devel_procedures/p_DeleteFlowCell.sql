USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_DeleteFlowCell]    Script Date: 11/20/2009 15:44:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_DeleteFlowCell](@id INTEGER)

AS
BEGIN
SET NOCOUNT ON

DELETE FROM external_barcode WHERE external_barcode_id IN (
SELECT eb.external_barcode_id FROM external_barcode eb INNER JOIN kind k ON
(k.kind_id = eb.kind_id) WHERE k.name = 'CONTAINER' and eb.identifiable_id = @id)

DELETE FROM contents WHERE child_container_id = @id

DELETE FROM flow_cell_well WHERE flow_cell_id = @id

DELETE FROM flow_cell WHERE flow_cell_id = @id

DELETE FROM generic_container WHERE generic_container_id = @id


SET NOCOUNT OFF
END
