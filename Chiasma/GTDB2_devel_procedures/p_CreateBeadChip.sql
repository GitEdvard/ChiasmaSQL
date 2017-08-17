USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreateBeadChip]    Script Date: 11/16/2009 13:34:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_CreateBeadChip](
	@identifier VARCHAR(255),
	@bead_chip_type_id INTEGER,
	@external_barcode VARCHAR(255) = NULL)

AS
BEGIN
SET NOCOUNT ON

DECLARE @bead_chip_id INTEGER

-- Get the ID from the generic_container table.
INSERT INTO generic_container (generic_container_type) VALUES ('BeadChip')

SET @bead_chip_id = SCOPE_IDENTITY()

-- Create BeadChip.
INSERT INTO bead_chip
	(bead_chip_id,
	 identifier,
	 bead_chip_type_id)
VALUES
	(@bead_chip_id,
	 @identifier, 
	 @bead_chip_type_id)
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to create BeadChip with identifier: %s', 15, 1, @identifier)
	RETURN
END

-- Get bead_chip_id.
SET @bead_chip_id = NULL

SELECT @bead_chip_id = bead_chip_id FROM bead_chip WHERE identifier = @identifier
IF @bead_chip_id IS NULL
BEGIN
	RAISERROR('bead_chip_id for BeadChip was not found', 15, 1)
	RETURN
END

-- Create bar code.
EXECUTE p_CreateExternalBarcode @barcode = @external_barcode,  @identifiable_id = @bead_chip_id, @kind = 'CONTAINER'

-- Return BeadChip.
SELECT
	bead_chip.bead_chip_id AS id,
	bead_chip.bead_chip_type_id,
	bead_chip.identifier,
	bead_chip.status,
	bead_chip.comment,
	barcode.code as barcode
FROM bead_chip
LEFT OUTER JOIN barcode ON barcode.identifiable_id = bead_chip.bead_chip_id AND barcode.kind = 'CONTAINER'
WHERE bead_chip_id = @bead_chip_id

SET NOCOUNT OFF
END
