USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreateProject]    Script Date: 11/16/2009 13:38:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_CreateProject](
	@identifier VARCHAR(255),
	@comment VARCHAR(1024) = NULL,
	@qcdb_id INTEGER)

AS
BEGIN
SET NOCOUNT ON

-- Create project, the new way.
INSERT INTO project (identifier, qcdb_id, comment)
	VALUES (@identifier, @qcdb_id, @comment)
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to create project with name: %s', 15, 1, @identifier)
	RETURN
END
		
SELECT
	project_id AS id,
	identifier,
	qcdb_id,
	comment
FROM project
WHERE identifier = @identifier

SET NOCOUNT OFF
END
