USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_DeleteAliquot]    Script Date: 11/20/2009 15:42:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_DeleteAliquot](
	@plate_id INTEGER,
	@position_x INTEGER,
	@position_y INTEGER)

AS
BEGIN
SET NOCOUNT ON

-- Delete aliquot at specified plate and position.
DELETE FROM aliquot 
WHERE
	plate_id = @plate_id AND
	position_x = @position_x AND
	position_y = @position_y

SET NOCOUNT OFF
END
