USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetIndividualsByIdentifierFilter]    Script Date: 11/20/2009 16:00:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_GetIndividualsByIdentifierFilter] (@identifier_filter VARCHAR(255))

AS
BEGIN
SET NOCOUNT OFF

SELECT
	ind.individual_id AS id,
	ind.identifier AS identifier,
	ind.external_name AS external_name,
	ind.species_id AS species_id,
	ind.individual_usage AS individual_usage,
	CONVERT( INTEGER, ind.sex) AS sex_id,
	ind.comment AS comment,
	indf.individual_id AS father_id,
	indf.identifier AS father_identifier,
	indf.external_name AS father_external_name,
	indf.species_id AS father_species_id,
	CONVERT( INTEGER, indf.sex) AS father_sex_id,
	indf.father_id AS father_father_id,
	indf.mother_id AS father_mother_id,
	indf.individual_usage AS father_individual_usage,
	indm.individual_id AS mother_id,
	indm.identifier AS mother_identifier,
	indm.external_name AS mother_external_name,
	indm.species_id AS mother_species_id,
	CONVERT( INTEGER, indm.sex) AS mother_sex_id,
	indm.father_id AS mother_father_id,
	indm.mother_id AS mother_mother_id,
	indm.individual_usage AS mother_individual_usage,
	ISNULL(ns.number, 0) AS sample_count
FROM individual ind
LEFT OUTER JOIN individual indf ON indf.individual_id = ind.father_id
LEFT OUTER JOIN individual indm ON indm.individual_id = ind.mother_id
LEFT OUTER JOIN
	(SELECT s.individual_id, COUNT(s.sample_id) AS number FROM sample AS s
	 GROUP BY s.individual_id) ns ON ns.individual_id = ind.individual_id
WHERE ind.identifier LIKE @identifier_filter
ORDER BY ind.identifier

SET NOCOUNT OFF
END
