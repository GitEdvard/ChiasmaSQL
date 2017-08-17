USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdateTubeAliquotFragmentLength]    Script Date: 11/20/2009 16:26:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[p_UpdateTubeAliquotFragmentLength](
	@id INTEGER,
	@fragment_length INTEGER,
	@fragment_length_device_id INTEGER,
	@comment VARCHAR(1024) = NULL)

AS
BEGIN
SET NOCOUNT ON

-- Update aliquot.
UPDATE tube_aliquot SET
	fragment_length = @fragment_length,
	fragment_length_device_id = @fragment_length_device_id,
	comment = @comment
WHERE tube_aliquot_id = @id
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update tube_aliquot with id: %d', 15, 1, @id)
	RETURN
END

SET NOCOUNT OFF
END
