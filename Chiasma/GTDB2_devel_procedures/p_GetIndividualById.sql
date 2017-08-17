USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetIndividualById]    Script Date: 11/20/2009 16:00:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_GetIndividualById] (@id INTEGER)

AS
BEGIN
SET NOCOUNT ON

SELECT
	individual_id AS id,
	identifier,
	external_name,
	species_id,
	CONVERT( INTEGER, sex) AS sex_id,
	father_id,
	mother_id,
	individual_usage,
	comment
FROM individual
WHERE individual_id = @id

SET NOCOUNT OFF
END
