USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreateProjectMapping]    Script Date: 11/16/2009 13:38:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_CreateProjectMapping](
	@id INTEGER,
	@project_id INTEGER)

AS
BEGIN
SET NOCOUNT ON

-- Create project mapping.
INSERT INTO project_mapping (project_group_id, project_id)
VALUES (@id, @project_id)
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to create project mapping with project group id: %d', 15, 1, @id)
	RETURN
END

SET NOCOUNT OFF
END
