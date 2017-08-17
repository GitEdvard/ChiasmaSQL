USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetMarkerWorkingSetHistory]    Script Date: 11/20/2009 16:02:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_GetMarkerWorkingSetHistory] (@id INTEGER)

AS
BEGIN
SET NOCOUNT ON

SELECT 
	marker.identifier,
	wset_member_log.operation,
	wset_member_log.log_date AS date_time,
	wset_member_log.authority_id
FROM wset_member_log
INNER JOIN marker ON marker.marker_id = wset_member_log.identifiable_id
WHERE wset_member_log.wset_id = @id
ORDER BY wset_member_log.log_date ASC

SET NOCOUNT OFF
END
