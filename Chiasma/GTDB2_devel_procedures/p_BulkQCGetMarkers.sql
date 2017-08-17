USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_BulkQCGetMarkers]    Script Date: 11/16/2009 13:33:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_BulkQCGetMarkers]

AS
BEGIN
SET NOCOUNT ON

SELECT m.marker_id AS id, m.identifier, md.chromosome, CASE WHEN (avf.is_top_in_forward = 1) THEN av.variant ELSE av.complement END AS variant
FROM marker m
	LEFT OUTER JOIN marker_details md ON md.marker_id = m.marker_id
	LEFT OUTER JOIN allele_variant_forward avf ON (m.marker_id = avf.marker_id)
	LEFT OUTER JOIN allele_variant av ON (avf.allele_variant_id = av.allele_variant_id)
WHERE m.identifier in (SELECT name FROM #BulkQCMarker)

SET NOCOUNT OFF
END


