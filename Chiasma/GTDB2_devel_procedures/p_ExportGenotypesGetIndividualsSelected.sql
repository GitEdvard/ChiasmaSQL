USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_ExportGenotypesGetIndividualsSelected]    Script Date: 11/20/2009 15:54:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_ExportGenotypesGetIndividualsSelected]

AS
BEGIN
SET NOCOUNT ON

SELECT individual_id AS id, identifier, external_name, father_id, mother_id, individual_usage
FROM individual
WHERE identifier in (SELECT name FROM #ExportGenotypesItem)
AND individual_usage = 'Genotyping'	order by external_name asc

SET NOCOUNT OFF
END
