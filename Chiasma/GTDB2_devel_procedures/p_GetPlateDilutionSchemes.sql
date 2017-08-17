USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetPlateDilutionSchemes]    Script Date: 11/20/2009 16:02:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_GetPlateDilutionSchemes] (@plate_type_id INTEGER)

AS
BEGIN
SET NOCOUNT ON

SELECT 
	plate_dilution_scheme_id AS id,
	identifier,
	plate_type_id,
	comment
FROM plate_dilution_scheme
WHERE plate_type_id = @plate_type_id
ORDER BY identifier ASC

SET NOCOUNT OFF
END
