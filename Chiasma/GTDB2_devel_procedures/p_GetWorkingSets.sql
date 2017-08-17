USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetWorkingSets]    Script Date: 11/20/2009 16:11:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_GetWorkingSets](
	@id INTEGER,
	@identifier_filter VARCHAR(255) )

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
	wset.project_id = @id AND
	wset.identifier LIKE @identifier_filter AND
	(wset_type_code.name = 'AssaySet' OR
	 wset_type_code.name = 'GenotypeSet' OR
	 wset_type_code.name = 'MarkerSet' OR
	 wset_type_code.name = 'PlateSet' OR
	 wset_type_code.name = 'SampleSet') 
ORDER BY wset.identifier ASC

SET NOCOUNT OFF
END
