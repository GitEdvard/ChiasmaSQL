USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetIndividualsByExternalName]    Script Date: 11/20/2009 16:00:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_GetIndividualsByExternalName] (@external_name VARCHAR(255))

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
WHERE external_name = @external_name

SET NOCOUNT OFF
END
