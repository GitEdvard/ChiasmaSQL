USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetQualityControlDatabases]    Script Date: 11/20/2009 16:05:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_GetQualityControlDatabases]

AS
BEGIN
SET NOCOUNT ON

SELECT 
	qcdb_id AS id,
	qcdb_name AS identifier,
	description
FROM qcdb
ORDER BY qcdb_name ASC

SET NOCOUNT OFF
END
