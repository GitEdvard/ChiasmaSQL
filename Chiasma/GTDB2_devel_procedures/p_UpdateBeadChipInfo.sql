USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdateBeadChipInfo]    Script Date: 11/16/2009 13:37:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_UpdateBeadChipInfo](
	@id INTEGER,
	@multiple_batches BIT,
	@batch_size INTEGER,
	@default_bead_chip_type_id INTEGER,
	@n_completed_batches INTEGER)

AS
BEGIN
SET NOCOUNT ON


-- update bead_chip_info.
UPDATE bead_chip_info SET 
	multiple_batches = @multiple_batches, 
	batch_size = @batch_size,
	default_bead_chip_type_id = @default_bead_chip_type_id,
	n_completed_batches = @n_completed_batches 
WHERE
	bead_chip_info_id = @id

IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update bead_chip_info with bead_chip_info_id: %s', 15, 1, @id)
	RETURN
END



SET NOCOUNT OFF
END
