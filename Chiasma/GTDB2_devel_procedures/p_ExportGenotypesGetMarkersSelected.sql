USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_ExportGenotypesGetMarkersSelected]    Script Date: 11/20/2009 15:54:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_ExportGenotypesGetMarkersSelected](
@is_bulk BIT
)

AS
BEGIN
SET NOCOUNT ON

IF @is_bulk = 0
BEGIN
	-- not bulk
	SELECT m.marker_id AS id, m.identifier, md.chromosome, dbo.fTopPolarizeAlleleVariantFromMarker(m.marker_id) AS variant
	FROM marker m
		LEFT OUTER JOIN marker_details md ON md.marker_id = m.marker_id
	WHERE m.identifier in (SELECT name FROM #ExportGenotypesMarker)
	order by m.identifier asc
END
ELSE
BEGIN
	-- Case when report is bulk
	SELECT m.marker_id AS id, m.identifier, md.chromosome, CASE WHEN (avf.is_top_in_forward = 1) THEN av.variant ELSE av.complement END AS variant
	FROM marker m
		LEFT OUTER JOIN marker_details md ON md.marker_id = m.marker_id
		LEFT OUTER JOIN allele_variant_forward avf ON (m.marker_id = avf.marker_id)
		LEFT OUTER JOIN allele_variant av ON (avf.allele_variant_id = av.allele_variant_id)
	WHERE m.identifier in (SELECT name FROM #ExportGenotypesMarker) 
	order by m.identifier asc
END
SET NOCOUNT OFF
END
