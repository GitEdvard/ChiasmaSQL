USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetProjectHistory]    Script Date: 11/20/2009 16:04:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_GetProjectHistory]( @id INTEGER )

AS
BEGIN
SET NOCOUNT ON

SELECT 
	project_id AS id,
	identifier,
	comment,
	changed_date,
	changed_authority_id,
	changed_action
FROM project_history
WHERE project_id = @id
ORDER BY changed_date ASC

SET NOCOUNT OFF
END
