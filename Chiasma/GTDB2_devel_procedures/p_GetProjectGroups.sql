USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetProjectGroups]    Script Date: 11/20/2009 16:04:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_GetProjectGroups]

AS
BEGIN
SET NOCOUNT ON

SELECT 
	project_group_id AS id,
	identifier,
	comment
FROM project_group
ORDER BY identifier ASC

SET NOCOUNT OFF
END
