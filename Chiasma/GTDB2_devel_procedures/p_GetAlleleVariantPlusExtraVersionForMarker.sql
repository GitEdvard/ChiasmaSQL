USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetAlleleVariantPlusExtraVersionForMarker]    Script Date: 11/20/2009 15:58:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_GetAlleleVariantPlusExtraVersionForMarker](@marker_id INTEGER)

AS
BEGIN
SET NOCOUNT ON

SELECT 
	avpev.allele_variant_plus_extra_version_id as id,
	avpev.allele_variant_id,
	avpev.is_top_in_plus,
	avpev.version,
	avpev.marker_id
FROM
	allele_variant_plus_extra_version avpev 
WHERE
	avpev.marker_id = @marker_id


SET NOCOUNT OFF
END


