USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdatePrimerComment]    Script Date: 11/20/2009 16:28:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_UpdatePrimerComment](
	@id INTEGER,
	@comment VARCHAR(6000) = NULL)

AS
BEGIN
SET NOCOUNT ON

-- Update the comment.
UPDATE primer SET comment = @comment WHERE primer_id = @id
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update primer with id: %d', 15, 1, @id)
	RETURN
END


SET NOCOUNT OFF

END
