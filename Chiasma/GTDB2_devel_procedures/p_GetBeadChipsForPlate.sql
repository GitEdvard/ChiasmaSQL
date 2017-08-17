USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetBeadChipsForPlate]    Script Date: 11/20/2009 15:55:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_GetBeadChipsForPlate](@plate_id INTEGER)

AS
BEGIN
SET NOCOUNT ON

SELECT DISTINCT
	bead_chip.bead_chip_id AS id,
	bead_chip.bead_chip_type_id,
	bead_chip.identifier,
	bead_chip.status,
	bead_chip.comment,
	barcode.code AS barcode
FROM bead_chip
INNER JOIN bead_chip_well ON bead_chip_well.bead_chip_id = bead_chip.bead_chip_id
LEFT OUTER JOIN barcode ON barcode.identifiable_id = bead_chip.bead_chip_id AND barcode.kind = 'CONTAINER'
WHERE
	bead_chip_well.source_container_id = @plate_id AND
	bead_chip.status = 'Active'

SET NOCOUNT OFF
END
