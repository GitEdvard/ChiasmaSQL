USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetIndividualHistory]    Script Date: 11/20/2009 16:00:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_GetIndividualHistory] (@id INTEGER)

AS
BEGIN
SET NOCOUNT OFF

SELECT
	individual_id AS id,
	identifier,
	external_name,
	species_id,
	individual_usage,
	CONVERT( INTEGER, sex) AS sex_id,
	father_id,
	mother_id,
	comment,
	changed_date,
	changed_authority_id,
	changed_action
FROM individual_history
WHERE individual_id = @id
ORDER BY changed_date ASC

SET NOCOUNT OFF
END
