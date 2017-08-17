USE [GTDB2_devel]
GO
/****** Object:  UserDefinedFunction [dbo].[fTopPolarizeAlleleResult]    Script Date: 11/20/2009 14:10:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[fTopPolarizeAlleleResult](@allele_result_id TINYINT, @assay_id INTEGER)
RETURNS VARCHAR(3)

--The function will return the allele_result name or the complementing
--name, depending on the top/bot designation of the assay.

AS
BEGIN

DECLARE @assay_designation CHAR(1)
DECLARE @return_value VARCHAR(3)


-- Find the top/bot designation of the assay.
SELECT @assay_designation = dbo.fDetermineTopBot(@assay_id)

IF @assay_designation IS NULL RETURN NULL

IF NOT (@assay_designation = 'T' OR @assay_designation = 'B') RETURN NULL

IF @assay_designation = 'T'
	SELECT @return_value = name FROM dbo.allele_result WHERE allele_result_id = @allele_result_id
ELSE 
	SELECT @return_Value = complement FROM dbo.allele_result WHERE allele_result_id = @allele_result_id


RETURN @return_value

END
