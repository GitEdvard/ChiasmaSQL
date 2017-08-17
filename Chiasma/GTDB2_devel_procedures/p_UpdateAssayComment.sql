USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdateAssayComment]    Script Date: 11/20/2009 16:26:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_UpdateAssayComment](
	@id INTEGER,
	@comment VARCHAR(6000) = NULL)

AS
BEGIN
SET NOCOUNT ON

-- Update the comment.
UPDATE assay SET comment = @comment WHERE assay_id = @id
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update assay with id: %d', 15, 1, @id)
	RETURN
END


SET NOCOUNT OFF

END
