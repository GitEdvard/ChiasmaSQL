USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetResultPlateWorkingSetHistory]    Script Date: 11/20/2009 16:06:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_GetResultPlateWorkingSetHistory] (@id INTEGER)

AS
BEGIN

SELECT 
	ISNULL(result_plate.identifier, result_plate_history.identifier) AS identifier,
	wset_member_log.operation,
	wset_member_log.log_date AS date_time,
	wset_member_log.authority_id
FROM wset_member_log
LEFT OUTER JOIN result_plate ON result_plate.result_plate_id = wset_member_log.identifiable_id
LEFT OUTER JOIN result_plate_history ON result_plate_history.result_plate_id = wset_member_log.identifiable_id
WHERE wset_member_log.wset_id = @id
ORDER BY wset_member_log.log_date ASC

END
