USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetInternalReportMarkerStatistics]    Script Date: 11/20/2009 16:01:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_GetInternalReportMarkerStatistics]( @id INTEGER )

AS
BEGIN
SET NOCOUNT ON

SELECT
	m.identifier AS marker,
	m.marker_id,
	irms.XX,
	irms.YY,
	irms.XY,
	irms.NA,
	irms.dupl_fail,
	irms.dupl_test,
	irms.inh_fail,
	irms.inh_test,
	irms.ctrl_inh_fail,
	irms.ctrl_inh_test,
	irms.comment
FROM internal_report_marker_stat irms
	INNER JOIN marker m ON m.marker_id = irms.marker_id 
WHERE irms.internal_report_id = @id

SET NOCOUNT OFF
END
