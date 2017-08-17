USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetPlateDilutionWells]    Script Date: 11/20/2009 16:02:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_GetPlateDilutionWells]( @plate_dilution_scheme_id INTEGER )

AS
BEGIN
SET NOCOUNT ON

SELECT * FROM plate_dilution_well
WHERE plate_dilution_scheme_id = @plate_dilution_scheme_id

SET NOCOUNT OFF
END
