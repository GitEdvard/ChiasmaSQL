USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_DeletePlate]    Script Date: 11/20/2009 15:45:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_DeletePlate](@id INTEGER)

AS
BEGIN
SET NOCOUNT ON

DELETE FROM external_barcode WHERE external_barcode_id IN (
SELECT eb.external_barcode_id FROM external_barcode eb INNER JOIN kind k ON
(k.kind_id = eb.kind_id) WHERE k.name = 'CONTAINER' and eb.identifiable_id = @id)

DELETE FROM contents WHERE child_container_id = @id

DELETE FROM aliquot WHERE plate_id = @id

DELETE FROM tube_aliquot WHERE plate_id = @id

DELETE FROM pool_info_for_aliquots WHERE plate_id = @id

UPDATE sample SET plate_id = NULL WHERE plate_id = @id

update plate set bead_chip_info_id = null where plate_id = @id

delete from bead_chip_info where plate_id = @id

DELETE FROM plate WHERE plate_id = @id

DELETE FROM generic_container WHERE generic_container_id = @id


SET NOCOUNT OFF
END
