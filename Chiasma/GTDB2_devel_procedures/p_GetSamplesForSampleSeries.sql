USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetSamplesForSampleSeries]    Script Date: 11/20/2009 16:07:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_GetSamplesForSampleSeries](@sample_series_id INTEGER)

AS
BEGIN
SET NOCOUNT ON

SELECT 
	sv.*,
	individual.identifier AS individual_identifier,
	individual.external_name AS individual_external_name,
	individual.species_id AS individual_species_id,
	CONVERT( INTEGER, individual.sex) AS individual_sex_id,
	individual.father_id AS individual_father_id,
	individual.mother_id AS individual_mother_id,
	individual.individual_usage AS individual_individual_usage	
FROM sample_view sv
INNER JOIN individual ON individual.individual_id = sv.individual_id
WHERE sv.sample_series_id = @sample_series_id
ORDER BY sv.identifier ASC


SET NOCOUNT OFF
END
