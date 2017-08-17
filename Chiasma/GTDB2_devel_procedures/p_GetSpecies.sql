USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetSpecies]    Script Date: 11/20/2009 16:08:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_GetSpecies]

AS
BEGIN
SET NOCOUNT ON

SELECT species_id AS id, identifier FROM species
ORDER BY identifier ASC

SET NOCOUNT OFF
END
