USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_ExportGenotypesGetMarkersSelectedInForward]    Script Date: 11/20/2009 15:54:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_ExportGenotypesGetMarkersSelectedInForward]

AS
BEGIN
SET NOCOUNT ON

-- Select markers that are in the temp-table #ExportGe...
-- Match with marker in allele_variant_forward
-- If more than one identical marker_id in allele_variant_forward, take the 
-- one with highest version number
SELECT m.marker_id AS id, m.identifier, avf.version, av.variant, avf.is_top_in_forward
	FROM marker m
	INNER JOIN allele_variant_forward avf ON (avf.marker_id = m.marker_id)
	INNER JOIN allele_variant av ON (av.allele_variant_id = avf.allele_variant_id)
WHERE m.identifier in 
	(SELECT name FROM #ExportGenotypesMarker)
ORDER BY m.identifier ASC

SET NOCOUNT OFF
END
