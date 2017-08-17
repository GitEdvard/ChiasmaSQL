USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetProjectsForUser]    Script Date: 11/20/2009 16:05:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_GetProjectsForUser](
	@user_id INTEGER,
	@project_identifier_filter VARCHAR(255))

AS
BEGIN
SET NOCOUNT ON

SELECT
	project.project_id
FROM project
INNER JOIN authority_group ON project.project_id = authority_group.identifiable_id AND authority_group.authority_group_type = 'Project'
INNER JOIN authority_mapping ON authority_group.authority_group_id = authority_mapping.authority_group_id 
WHERE 
	authority_mapping.authority_id = @user_id AND
	project.identifier LIKE @project_identifier_filter
ORDER BY project.identifier ASC

SET NOCOUNT OFF
END
