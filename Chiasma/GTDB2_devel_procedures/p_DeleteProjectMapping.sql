USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_DeleteProjectMapping]    Script Date: 11/20/2009 15:45:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_DeleteProjectMapping](
	@id INTEGER,
	@project_id INTEGER)

AS
BEGIN
SET NOCOUNT ON

-- Delete project mapping.
DELETE FROM project_mapping
WHERE
	project_group_id = @id AND
	project_id = @project_id

SET NOCOUNT OFF
END
