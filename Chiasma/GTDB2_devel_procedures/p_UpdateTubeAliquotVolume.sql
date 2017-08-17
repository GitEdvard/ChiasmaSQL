USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdateTubeAliquotVolume]    Script Date: 11/20/2009 16:26:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_UpdateTubeAliquotVolume](
	@id INTEGER,
	@volume FLOAT,
	@comment VARCHAR(1024) = NULL)

AS
BEGIN
SET NOCOUNT ON

-- Update aliquot.
UPDATE tube_aliquot SET
	volume = @volume,
	comment = @comment
WHERE tube_aliquot_id = @id
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update tube_aliquot with id: %d', 15, 1, @id)
	RETURN
END

SET NOCOUNT OFF
END
