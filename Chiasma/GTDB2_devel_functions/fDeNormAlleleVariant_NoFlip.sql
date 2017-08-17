USE [GTDB2_devel]
GO
/****** Object:  UserDefinedFunction [dbo].[fDeNormAlleleVariant_NoFlip]    Script Date: 11/20/2009 14:09:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fDeNormAlleleVariant_NoFlip] ( @assay_id INTEGER )
RETURNS VARCHAR(10)

AS
BEGIN

DECLARE @allele_variants VARCHAR(10)
SET @allele_variants = ''

--CHECKING FIRST IF THE ASSAY EXISTS
IF NOT EXISTS( SELECT assay_id FROM assay WHERE assay_id = @assay_id)
BEGIN
	RETURN 'FAILED'
END 

SELECT @allele_variants = av.variant
FROM assay a
INNER JOIN allele_variant av ON av.allele_variant_id = a.allele_variant_id
WHERE a.assay_id = @assay_id


RETURN @allele_variants

END


