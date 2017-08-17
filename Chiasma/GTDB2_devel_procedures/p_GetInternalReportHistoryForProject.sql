USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetInternalReportHistoryForProject]    Script Date: 11/20/2009 16:01:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_GetInternalReportHistoryForProject]( @project_id INTEGER )

AS
BEGIN
SET NOCOUNT ON

SELECT 
	internal_report_id AS id,
	identifier,
	authority_id,
	project_id,
	source,
	is_bulk,
	comment,
	uploading_flag,
	changed_date,
	changed_authority_id,
	changed_action
FROM internal_report_history
WHERE project_id = @project_id
ORDER BY changed_date ASC


SET NOCOUNT OFF
END
