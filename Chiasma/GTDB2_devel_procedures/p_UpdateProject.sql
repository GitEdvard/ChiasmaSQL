USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdateProject]    Script Date: 11/20/2009 16:28:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_UpdateProject](
	@id INTEGER,
	@comment VARCHAR(1024) = NULL,
	@qcdb_id INTEGER = NULL)

AS
BEGIN
SET NOCOUNT ON

-- Update project in the new way.
UPDATE project SET
	comment = @comment,
	qcdb_id = @qcdb_id
WHERE project_id = @id
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update project with id: %d', 15, 1, @id)
	RETURN
END

SET NOCOUNT OFF
END
