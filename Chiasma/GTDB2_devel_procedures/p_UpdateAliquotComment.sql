USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdateAliquotComment]    Script Date: 11/20/2009 16:26:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_UpdateAliquotComment](
	@plate_id INTEGER,
	@position_x INTEGER,
	@position_y INTEGER,
	@comment VARCHAR(1024) = NULL)

AS
BEGIN
SET NOCOUNT ON

-- Update aliquot.
UPDATE aliquot SET
	comment = @comment
WHERE plate_id = @plate_id AND position_x = @position_x AND position_y = @position_y
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update aliquot with id: %d', 15, 1, @plate_id)
	RETURN
END

SET NOCOUNT OFF
END
