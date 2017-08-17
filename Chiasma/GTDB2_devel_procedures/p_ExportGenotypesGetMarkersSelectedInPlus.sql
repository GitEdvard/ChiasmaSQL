USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_ExportGenotypesGetMarkersSelectedInPlus]    Script Date: 11/20/2009 15:54:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_ExportGenotypesGetMarkersSelectedInPlus]

AS
BEGIN
SET NOCOUNT ON

SELECT m.marker_id AS id, m.identifier, avp.version, av.variant, avp.is_top_in_plus
	FROM marker m INNER JOIN allele_variant_plus avp ON
		(avp.marker_id = m.marker_id) 
	INNER JOIN allele_variant av ON (av.allele_variant_id = avp.allele_variant_id) 
WHERE m.identifier in 
	(SELECT name FROM #ExportGenotypesMarker)
ORDER BY m.identifier ASC

SET NOCOUNT OFF
END
