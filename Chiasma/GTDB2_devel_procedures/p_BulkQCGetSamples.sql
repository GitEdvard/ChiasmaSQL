USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_BulkQCGetSamples]    Script Date: 11/16/2009 13:33:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_BulkQCGetSamples]

AS
BEGIN
SET NOCOUNT ON

SELECT s.sample_id AS id, s.identifier, s.external_name, s.individual_id, i.individual_usage
FROM sample s
	INNER JOIN individual i ON i.individual_id = s.individual_id
WHERE s.identifier in (SELECT name FROM #BulkQCSample)

SET NOCOUNT OFF
END
