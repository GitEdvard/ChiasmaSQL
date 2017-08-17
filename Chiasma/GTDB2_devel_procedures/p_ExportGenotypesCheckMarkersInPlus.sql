USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_ExportGenotypesCheckMarkersInPlus]    Script Date: 11/20/2009 15:54:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_ExportGenotypesCheckMarkersInPlus]

AS
BEGIN
SET NOCOUNT ON

SELECT tm.name AS identifier
FROM #ExportGenotypesMarker tm
INNER JOIN marker m ON (m.identifier = tm.name)
WHERE m.marker_id NOT IN (SELECT marker_id FROM allele_variant_plus)

SET NOCOUNT OFF
END
