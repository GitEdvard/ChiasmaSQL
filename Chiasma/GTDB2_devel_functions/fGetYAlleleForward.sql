USE [GTDB2_devel]
GO
/****** Object:  UserDefinedFunction [dbo].[fGetYAlleleForward]    Script Date: 11/20/2009 14:10:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fGetYAlleleForward](@marker_id INTEGER)
RETURNS VARCHAR(2)

AS
BEGIN

DECLARE @y_allele CHAR
DECLARE @variant CHAR(3)

SELECT TOP (1) @variant = av.variant FROM 
allele_variant_forward avf INNER JOIN
allele_variant av ON (avf.allele_variant_id = av.allele_variant_id)
WHERE avf.marker_id = @marker_id 
ORDER BY CAST(avf.version AS FLOAT) DESC

IF @variant IS NULL
BEGIN
	RETURN 'NA'
END 

SET @y_allele = SUBSTRING(@variant, 3, 1)

RETURN @y_allele


END


