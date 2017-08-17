USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdateBeadChipType]    Script Date: 11/20/2009 16:27:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_UpdateBeadChipType](
	@id INTEGER,
	@default_batch_size INTEGER,
	@status varchar(30))

AS
BEGIN
SET NOCOUNT ON

-- Update BeadChip.
UPDATE bead_chip_type
SET
	default_batch_size = @default_batch_size,
	status = @status
WHERE bead_chip_type_id = @id
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update BeadChip type with id: %d', 15, 1, @id)
	RETURN
END

SET NOCOUNT OFF
END
