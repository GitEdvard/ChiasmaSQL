USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdateSampleNoContainer]    Script Date: 11/20/2009 16:30:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[p_UpdateSampleNoContainer] (@id INTEGER)

AS
BEGIN
SET NOCOUNT ON

-- Update sample.
UPDATE sample SET
	pos_x = NULL,
	pos_y = NULL,
	pos_z = NULL,
	tube_id = null,
	plate_id = null
WHERE sample_id = @id
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update sample with id: %d', 15, 1, @id)
	RETURN
END

SET NOCOUNT OFF
END
