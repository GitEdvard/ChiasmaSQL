USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetIndividualsForPlate]    Script Date: 11/20/2009 16:01:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_GetIndividualsForPlate] (@id INTEGER)

AS
BEGIN
SET NOCOUNT ON

-- Get individuals for MasterPlate
SELECT 
	sample.sample_id AS id,
	sample.pos_x AS position_x,
	sample.pos_y AS position_y,
	ind.individual_id AS individual_id,
	ind.identifier AS individual_identifier,
	ind.external_name AS individual_external_name,
	ind.species_id AS individual_species_id,
	ind.individual_usage AS individual_individual_usage,
	CONVERT( INTEGER, ind.sex) AS individual_sex_id,
	ind.comment AS comment,
	indf.individual_id AS individual_father_id,
	indf.identifier AS individual_father_identifier,
	indf.external_name AS individual_father_external_name,
	indf.species_id AS individual_father_species_id,
	CONVERT( INTEGER, indf.sex) AS individual_father_sex_id,
	indf.father_id AS individual_father_father_id,
	indf.mother_id AS individual_father_mother_id,
	indf.individual_usage AS individual_father_individual_usage,
	indm.individual_id AS individual_mother_id,
	indm.identifier AS individual_mother_identifier,
	indm.external_name AS individual_mother_external_name,
	indm.species_id AS individual_mother_species_id,
	CONVERT( INTEGER, indm.sex) AS individual_mother_sex_id,
	indm.father_id AS individual_mother_father_id,
	indm.mother_id AS individual_mother_mother_id,
	indm.individual_usage AS individual_mother_individual_usage
FROM individual ind
LEFT OUTER JOIN individual indf ON indf.individual_id = ind.father_id
LEFT OUTER JOIN individual indm ON indm.individual_id = ind.mother_id
INNER JOIN SAMPLE ON
sample.individual_id = ind.individual_id
WHERE sample.plate_id = @id

UNION

-- Get individuals for WorkingPlate
SELECT 
	sample.sample_id AS id,
	aliquot.position_x AS position_x,
	aliquot.position_y AS position_y,
	ind.individual_id AS individual_id,
	ind.identifier AS individual_identifier,
	ind.external_name AS individual_external_name,
	ind.species_id AS individual_species_id,
	ind.individual_usage AS individual_individual_usage,
	CONVERT( INTEGER, ind.sex) AS individual_sex_id,
	ind.comment AS commment,
	indf.individual_id AS individual_father_id,
	indf.identifier AS individual_father_identifier,
	indf.external_name AS individual_father_external_name,
	indf.species_id AS individual_father_species_id,
	CONVERT( INTEGER, indf.sex) AS individual_father_sex_id,
	indf.father_id AS individual_father_father_id,
	indf.mother_id AS individual_father_mother_id,
	indf.individual_usage AS individual_father_individual_usage,
	indm.individual_id AS individual_mother_id,
	indm.identifier AS individual_mother_identifier,
	indm.external_name AS individual_mother_external_name,
	indm.species_id AS individual_mother_species_id,
	CONVERT( INTEGER, indm.sex) AS individual_mother_sex_id,
	indm.father_id AS individual_mother_father_id,
	indm.mother_id AS individual_mother_mother_id,
	indm.individual_usage AS individual_mother_individual_usage
FROM individual ind
LEFT OUTER JOIN individual indf ON indf.individual_id = ind.father_id
LEFT OUTER JOIN individual indm ON indm.individual_id = ind.mother_id
INNER JOIN sample ON sample.individual_id = ind.individual_id
INNER JOIN aliquot ON aliquot.sample_id = sample.sample_id
WHERE aliquot.plate_id = @id

SET NOCOUNT OFF
END
