USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdateMarkerComment]    Script Date: 11/20/2009 16:28:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_UpdateMarkerComment](
	@id INTEGER,
	@comment VARCHAR(6000) = NULL)

AS
BEGIN
SET NOCOUNT ON

-- Update marker.
UPDATE marker SET
	comment = @comment
WHERE marker_id = @id
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update marker with id: %d', 15, 1, @id)
	RETURN
END

SET NOCOUNT OFF

END
