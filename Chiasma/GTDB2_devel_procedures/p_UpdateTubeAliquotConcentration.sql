USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdateTubeAliquotConcentration]    Script Date: 11/20/2009 16:26:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_UpdateTubeAliquotConcentration](
	@id INTEGER,
	@concentration FLOAT,
	@concentration_device_id INTEGER,
	@comment VARCHAR(1024) = NULL)

AS
BEGIN
SET NOCOUNT ON

-- Update aliquot.
UPDATE tube_aliquot SET
	concentration = @concentration,
	concentration_device_id = @concentration_device_id,
	comment = @comment
WHERE tube_aliquot_id = @id
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update tube_aliquot with id: %d', 15, 1, @id)
	RETURN
END

SET NOCOUNT OFF
END
