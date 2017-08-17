USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdatePoolInfoForAliquotsConcentration]    Script Date: 11/20/2009 16:26:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[p_UpdatePoolInfoForAliquotsConcentration](
	@id INTEGER,
	@concentration float = NULL,
	@concentration_device_id int = null,
	@comment varchar(1024) = null)

AS
BEGIN
SET NOCOUNT ON

-- Update pool_info_for_aliquots
UPDATE pool_info_for_aliquots SET
	concentration = @concentration,
	concentration_device_id = @concentration_device_id,
	comment = @comment
WHERE pool_info_for_aliquots_id = @id
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update tube_aliquot with id: %d', 15, 1, @id)
	RETURN
END

SET NOCOUNT OFF
END
