USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetProjectGroup]    Script Date: 11/20/2009 16:04:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_GetProjectGroup] (@identifier VARCHAR(255))

AS
BEGIN
SET NOCOUNT ON

SELECT 
	project_group_id AS id,
	identifier,
	comment
FROM project_group
WHERE identifier = @identifier

SET NOCOUNT OFF
END
