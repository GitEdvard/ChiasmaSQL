USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetBeadChipsForSample]    Script Date: 11/20/2009 15:56:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_GetBeadChipsForSample](@sample_id INTEGER)

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
	bead_chip_well.sample_id = @sample_id

SET NOCOUNT OFF
END
