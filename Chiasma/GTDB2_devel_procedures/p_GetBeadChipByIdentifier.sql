USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetBeadChipByIdentifier]    Script Date: 11/20/2009 15:55:39 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_GetBeadChipByIdentifier](@identifier VARCHAR(255))

AS
BEGIN
SET NOCOUNT ON

SELECT
	bead_chip.bead_chip_id AS id,
	bead_chip.bead_chip_type_id,
	bead_chip.identifier,
	bead_chip.status,
	bead_chip.comment,
	barcode.code AS barcode
FROM bead_chip
LEFT OUTER JOIN barcode ON barcode.identifiable_id = bead_chip.bead_chip_id AND barcode.kind = 'CONTAINER'
WHERE bead_chip.identifier = @identifier

SET NOCOUNT OFF
END
