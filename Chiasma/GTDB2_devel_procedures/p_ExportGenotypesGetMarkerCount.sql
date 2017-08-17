USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_BulkQCGetMarkers]    Script Date: 11/16/2009 13:33:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_ExportGenotypesGetMarkerCount]

AS
BEGIN
SET NOCOUNT ON

SELECT COUNT(m.marker_id) as marker_count
FROM marker m
WHERE m.identifier in (SELECT name FROM #ExportGenotypesMarker)

SET NOCOUNT OFF
END
