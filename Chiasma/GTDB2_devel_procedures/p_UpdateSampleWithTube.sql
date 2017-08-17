USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdateSampleWithTube]    Script Date: 11/20/2009 16:30:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[p_UpdateSampleWithTube](
	@id INTEGER,
	@tube_id INTEGER)

AS
BEGIN
SET NOCOUNT ON

-- Update sample.
UPDATE sample SET
	tube_id = @tube_id,
	plate_id = null
WHERE sample_id = @id
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update sample with id: %d', 15, 1, @id)
	RETURN
END

SET NOCOUNT OFF
END
