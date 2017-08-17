USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdatePoolInfoForAliquotsComment]    Script Date: 11/20/2009 16:26:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_UpdatePoolInfoForAliquotsComment](
	@id INTEGER,
	@comment VARCHAR(1024) = NULL)

AS
BEGIN
SET NOCOUNT ON

-- Update pool_info_for_aliquots
UPDATE pool_info_for_aliquots SET
	comment = @comment
WHERE pool_info_for_aliquots_id = @id
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update tube_aliquot with id: %d', 15, 1, @id)
	RETURN
END

SET NOCOUNT OFF
END
