USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetProjects]    Script Date: 11/20/2009 16:05:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_GetProjects]

AS
BEGIN
SET NOCOUNT ON

SELECT
	project_id AS id,
	identifier,
	qcdb_id,
	comment
FROM project
ORDER BY identifier ASC

SET NOCOUNT OFF
END
