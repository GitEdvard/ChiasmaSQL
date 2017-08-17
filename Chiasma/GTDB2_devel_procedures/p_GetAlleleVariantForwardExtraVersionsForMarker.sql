USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetAlleleVariantForwardExtraVersionsForMarker]    Script Date: 11/20/2009 15:58:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_GetAlleleVariantForwardExtraVersionsForMarker](@marker_id INTEGER)

AS
BEGIN
SET NOCOUNT ON

SELECT 
	avfev.allele_variant_forward_extra_version_id as id,
	avfev.allele_variant_id,
	avfev.is_top_in_forward,
	avfev.version,
	avfev.marker_id
FROM
	allele_variant_forward_extra_version avfev 
WHERE
	avfev.marker_id = @marker_id


SET NOCOUNT OFF
END


