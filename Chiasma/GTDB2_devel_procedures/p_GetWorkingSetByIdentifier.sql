USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetWorkingSetByIdentifier]    Script Date: 11/20/2009 16:10:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_GetWorkingSetByIdentifier](@identifier VARCHAR(255) )

AS
BEGIN
SET NOCOUNT ON

SELECT 
	wset.wset_id AS id,
	wset.identifier AS identifier,
	wset.project_id AS project_id,
	wset_type_code.name AS working_set_type,
	wset.description AS description
FROM wset
INNER JOIN wset_type_code
ON wset_type_code.wset_type_id = wset.wset_type_id
WHERE
	wset.identifier = @identifier AND
	(wset_type_code.name = 'AssaySet' OR
	 wset_type_code.name = 'GenotypeSet' OR
	 wset_type_code.name = 'MarkerSet' OR
	 wset_type_code.name = 'PlateSet' OR
	 wset_type_code.name = 'SampleSet') 

SET NOCOUNT OFF
END
