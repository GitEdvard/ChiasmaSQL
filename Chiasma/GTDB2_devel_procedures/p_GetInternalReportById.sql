USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetInternalReportById]    Script Date: 11/20/2009 16:01:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_GetInternalReportById]( @id INTEGER )

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
	uploading_flag,	
	comment,
	settings
FROM internal_report
WHERE internal_report_id = @id

SET NOCOUNT OFF
END
