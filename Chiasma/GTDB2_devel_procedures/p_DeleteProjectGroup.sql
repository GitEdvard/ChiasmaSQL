USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_DeleteProjectGroup]    Script Date: 11/20/2009 15:45:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_DeleteProjectGroup] (@id INTEGER)

AS
BEGIN
SET NOCOUNT ON

-- Delete project group.
DELETE FROM project_group
WHERE project_group_id = @id

SET NOCOUNT OFF
END
