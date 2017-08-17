USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetIndividualsForInternalReport]    Script Date: 11/20/2009 16:01:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_GetIndividualsForInternalReport](@id INTEGER)

AS
BEGIN
SET NOCOUNT ON

SELECT 	i.individual_id AS id,
	i.identifier,
	i.external_name,
	i.species_id,
	CONVERT( INTEGER, i.sex) AS sex_id,
	i.father_id,
	i.mother_id,
	i.individual_usage,
	i.comment
FROM individual i
	INNER JOIN internal_report_indv_stat iris ON iris.individual_id = i.individual_id
WHERE iris.internal_report_id = @id
AND i.individual_usage = 'Genotyping' order by i.external_name asc

SET NOCOUNT OFF
END
