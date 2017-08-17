USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdatePoolInfoForSamplesVolume]    Script Date: 11/20/2009 16:26:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_UpdatePoolInfoForSamplesVolume](
	@id INTEGER,
	@volume float = NULL,
	@comment varchar(1024) = null)

AS
BEGIN
SET NOCOUNT ON

-- Update pool_info_for_aliquots
UPDATE pool_info_for_samples SET
	volume_current = @volume,
	comment = @comment
WHERE pool_info_for_samples_id = @id
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update pool info for samples with id: %d', 15, 1, @id)
	RETURN
END

-- Update samples

update sample set volume_current = @volume where pool_info_for_samples_id = @id
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update sample belonging to pool info for samples with id: %d', 15, 1, @id)
	RETURN
END


SET NOCOUNT OFF
END
