USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdatePoolInfoForAliquotsVolume]    Script Date: 11/20/2009 16:26:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[p_UpdatePoolInfoForAliquotsVolume](
	@id INTEGER,
	@volume float = NULL,
	@comment varchar(1024) = null)

AS
BEGIN
SET NOCOUNT ON

-- Update pool_info_for_aliquots
UPDATE pool_info_for_aliquots SET
	volume = @volume,
	comment = @comment
WHERE pool_info_for_aliquots_id = @id
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update tube_aliquot with id: %d', 15, 1, @id)
	RETURN
END

-- Update tube_aliquots

update tube_aliquot set volume = @volume where pool_info_for_aliquots_id = @id
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update tube_aliquot with id: %d', 15, 1, @id)
	RETURN
END


SET NOCOUNT OFF
END
