USE [GTDB2_devel]
GO
/****** Object:  UserDefinedFunction [dbo].[fTopPolarizeAlleleVariant]    Script Date: 11/20/2009 14:10:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fTopPolarizeAlleleVariant](@assay_id INTEGER)
RETURNS VARCHAR(3)

--The function will return the allele variant or the complementing
--allele variant, depending on the top/bot designation of the assay.

AS
BEGIN

DECLARE @allele_variant_id TINYINT
DECLARE @assay_designation CHAR(1)
DECLARE @return_value VARCHAR(3)


-- Find the allele variant of the assay.
SELECT @allele_variant_id = allele_variant_id FROM dbo.assay WHERE assay_id = @assay_id

-- Find the top/bot designation of the assay.
SELECT @assay_designation = dbo.fDetermineTopBot(@assay_id)

IF @assay_designation IS NULL RETURN NULL

IF NOT (@assay_designation = 'T' OR @assay_designation = 'B') RETURN NULL

IF @assay_designation = 'T'
	SELECT @return_value = variant FROM dbo.allele_variant
	WHERE allele_variant_id = @allele_variant_id	
ELSE 
	SELECT @return_value = complement FROM dbo.allele_variant
	WHERE allele_variant_id = @allele_variant_id


RETURN @return_value

END
