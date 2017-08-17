USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_ExportGenotypesGetSamplesSelected]    Script Date: 11/20/2009 15:54:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_ExportGenotypesGetSamplesSelected]

AS
BEGIN
SET NOCOUNT ON

SELECT s.sample_id AS id, s.identifier, s.external_name, s.individual_id, i.individual_usage

FROM sample s INNER JOIN individual i ON s.individual_id = i.individual_id
WHERE s.identifier in (SELECT name FROM #ExportGenotypesItem)
AND individual_usage = 'Genotyping'	order by s.external_name asc

SET NOCOUNT OFF
END


