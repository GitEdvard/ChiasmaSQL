	USE [GTDB2_devel]
GO
/****** Object:  UserDefinedFunction [dbo].[fGetYAlleleTop]    Script Date: 11/20/2009 14:10:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[fGetYAlleleTop](@marker_id INTEGER, @is_bulk BIT)
RETURNS VARCHAR(2)

AS
BEGIN

DECLARE @y_allele CHAR
DECLARE @assay_id INTEGER
DECLARE @variant CHAR(3)

IF @is_bulk = 0
BEGIN
	SELECT TOP (1) @assay_id = a.assay_id FROM assay a
	WHERE a.marker_id = @marker_id order by a.identifier desc

	IF @assay_id IS NULL
	BEGIN
		RETURN 'NA'
	END 

	SET @variant = dbo.fTopPolarizeAlleleVariant(@assay_id)

END
ELSE
BEGIN
	SELECT @variant = CASE WHEN (avf.is_top_in_forward = 1) THEN av.variant ELSE av.complement END 
	FROM allele_variant_forward avf
	INNER JOIN allele_variant av ON (av.allele_variant_id = avf.allele_variant_id)
	WHERE avf.marker_id = @marker_id
END	

IF @variant IS NULL
BEGIN
	RETURN 'NA'
END

SET @y_allele = SUBSTRING(@variant, 3, 1)

RETURN @y_allele


END


