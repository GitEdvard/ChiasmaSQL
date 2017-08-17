USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdatePrimerCommentAndOrientation]    Script Date: 11/20/2009 16:28:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_UpdatePrimerCommentAndOrientation](
	@id INTEGER,
	@comment VARCHAR(6000) = NULL,
	@orientation CHAR(1))

AS
BEGIN
SET NOCOUNT ON

-- Update the comment.
UPDATE primer SET comment = @comment, orientation = @orientation WHERE primer_id = @id
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update primer with id: %d', 15, 1, @id)
	RETURN
END


SET NOCOUNT OFF

END
