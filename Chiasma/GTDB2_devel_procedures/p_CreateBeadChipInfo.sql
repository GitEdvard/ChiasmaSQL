USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreateBeadChipInfo]    Script Date: 11/16/2009 13:37:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_CreateBeadChipInfo](
	@plate_id INTEGER,
	@multiple_batches BIT,
	@batch_size INTEGER,
	@default_bead_chip_type_id INTEGER,
	@n_completed_batches INTEGER = 0)

AS
BEGIN
SET NOCOUNT ON
DECLARE @id INTEGER

-- Create bead_chip_info.
INSERT INTO bead_chip_info
	(plate_id,
	 n_completed_batches,
	 multiple_batches,
	 batch_size,
	 default_bead_chip_type_id)
VALUES
	(@plate_id,
	 @n_completed_batches,
	 @multiple_batches,
	 @batch_size,
	 @default_bead_chip_type_id)
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to create bead_chip_info with plate_id: %s', 15, 1, @plate_id)
	RETURN
END

SET @id = SCOPE_IDENTITY()
--go
--
UPDATE plate SET bead_chip_info_id = @id WHERE plate_id = @plate_id
--go
--
SELECT
	bci.bead_chip_info_id as id,
	bci.default_bead_chip_type_id,
	bci.n_completed_batches as n_completed_batches,
	bci.multiple_batches as multiple_batches,
	bci.batch_size as batch_size
FROM bead_chip_info bci WHERE bci.bead_chip_info_id = @id


SET NOCOUNT OFF
END
