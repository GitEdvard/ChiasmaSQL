USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_ExportGenotypesCheckMarkersInForward]    Script Date: 11/20/2009 15:54:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_ExportGenotypesCheckMarkersInForward]

AS
BEGIN
SET NOCOUNT ON

SELECT tm.name AS identifier
FROM #ExportGenotypesMarker tm
INNER JOIN marker m ON (m.identifier = tm.name)
WHERE m.marker_id NOT IN (SELECT marker_id FROM allele_variant_forward)

SET NOCOUNT OFF
END
