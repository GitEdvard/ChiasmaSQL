USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetProjectMapping]    Script Date: 11/20/2009 16:04:45 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_GetProjectMapping] (@id INTEGER)

AS
BEGIN
SET NOCOUNT ON

SELECT project_id
FROM project_mapping
WHERE project_group_id = @id

SET NOCOUNT OFF
END
