USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdateSampleMolarConcentration]    Script Date: 11/20/2009 16:30:38 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[p_UpdateSampleMolarConcentration](
	@id INTEGER,
	@molar_concentration FLOAT,
	@molar_concentration_device_id INTEGER,
	@comment VARCHAR(1024) = NULL)

AS
BEGIN
SET NOCOUNT ON

-- Update sample.
UPDATE sample SET
	molar_concentration = @molar_concentration,
	molar_concentration_device_id = @molar_concentration_device_id,
	comment = @comment
WHERE sample_id = @id
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update sample with id: %d', 15, 1, @id)
	RETURN
END

SET NOCOUNT OFF
END
