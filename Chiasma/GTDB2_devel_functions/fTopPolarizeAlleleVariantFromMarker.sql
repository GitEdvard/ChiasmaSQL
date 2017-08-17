USE [GTDB2_devel]
GO
/****** Object:  UserDefinedFunction [dbo].[fTopPolarizeAlleleVariantFromMarker]    Script Date: 11/20/2009 14:10:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[fTopPolarizeAlleleVariantFromMarker](@marker_id INTEGER)
RETURNS VARCHAR(3)

--The function will return the allele variant or the complementing
--allele variant, depending on the top/bot designation of the assay.

AS
BEGIN

DECLARE @return_value VARCHAR(3)

SELECT TOP (1) @return_value = dbo.fTopPolarizeAlleleVariant(a.assay_id) FROM assay a WHERE
a.marker_id = @marker_id order by identifier desc

RETURN @return_value

END
