
USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_BulkQCGetIndividuals]    Script Date: 11/16/2009 13:33:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_BulkQCGetIndividuals]

AS
BEGIN
SET NOCOUNT ON

SELECT individual_id AS id, identifier, external_name, father_id, mother_id, individual_usage
FROM individual
WHERE individual_id in (SELECT individual_id FROM sample WHERE identifier IN (SELECT name FROM #BulkQCSample))

SET NOCOUNT OFF
END
