USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetProjectsByIdentifierFilter]    Script Date: 11/20/2009 16:05:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_GetProjectsByIdentifierFilter](@identifier_filter VARCHAR(255))

AS
BEGIN
SET NOCOUNT ON

SELECT
	project_id AS id,
	identifier,
	qcdb_id,
	comment
FROM project
WHERE identifier LIKE @identifier_filter
ORDER BY identifier ASC

SET NOCOUNT OFF
END
