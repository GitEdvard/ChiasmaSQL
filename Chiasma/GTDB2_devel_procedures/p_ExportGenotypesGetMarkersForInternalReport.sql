USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_ExportGenotypesGetMarkersForInternalReport]    Script Date: 11/20/2009 15:54:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_ExportGenotypesGetMarkersForInternalReport](@id INTEGER)

AS
BEGIN
SET NOCOUNT ON

SELECT m.identifier
FROM marker m
	INNER JOIN internal_report_marker_stat irms ON irms.marker_id = m.marker_id
	LEFT OUTER JOIN marker_details md ON md.marker_id = m.marker_id
WHERE irms.internal_report_id = @id order by m.identifier asc
	

SET NOCOUNT OFF
END
