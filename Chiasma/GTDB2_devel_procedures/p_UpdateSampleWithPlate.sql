USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdateSampleWithPlate]    Script Date: 11/20/2009 16:30:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[p_UpdateSampleWithPlate](
	@id INT,
	@plate_id INT,
	@pos_x INT,
	@pos_y INT)

AS
BEGIN
SET NOCOUNT ON

-- Update sample.
UPDATE sample SET
	plate_id = @plate_id,
	pos_x = @pos_x,
	pos_y = @pos_y,
	pos_z = 1,
	tube_id = null
WHERE sample_id = @id
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update sample with id: %d', 15, 1, @id)
	RETURN
END

SET NOCOUNT OFF
END
