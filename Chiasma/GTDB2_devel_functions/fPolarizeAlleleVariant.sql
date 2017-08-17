USE [GTDB2_devel]
GO
/****** Object:  UserDefinedFunction [dbo].[fPolarizeAlleleVariant]    Script Date: 11/20/2009 14:10:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fPolarizeAlleleVariant](@assayId INTEGER)
RETURNS VARCHAR(3)

--The function will return the allele variant or the complementing
--allele variant, depending on the direction of the extension primer for the assay.

AS
BEGIN

DECLARE @primerId INTEGER
DECLARE @primerOri CHAR(1)
DECLARE @alleleVariantId TINYINT
DECLARE @returnValue VARCHAR(3)



-- Find the id of the extension primer.
SELECT @primerId = MIN(p.primer_id)
FROM primer p
INNER JOIN primer_set ps ON (ps.primer_id = p.primer_id AND ps.assay_id = @assayId)
WHERE p.type = 'extension' 

IF @primerId IS NULL
BEGIN
	RETURN 'FAILED'
END

-- Find the direction of the extension primer.
SELECT @primerOri = orientation FROM primer WHERE primer_id = @primerId

IF (@primerOri IS NULL) AND (NOT @primerOri = 'R') AND (NOT @primerOri = 'F') 
BEGIN
	RETURN 'FAILED'	
END


SELECT @alleleVariantId = allele_variant_id FROM dbo.assay WHERE assay_id = @assayId

IF @primerOri = 'R'
BEGIN
	SELECT @returnValue = complement FROM dbo.allele_variant WHERE allele_variant_id = @alleleVariantId
END
ELSE
BEGIN
	SELECT @returnValue = variant FROM dbo.allele_variant WHERE allele_variant_id = @alleleVariantId
END

		
RETURN @returnValue
END
