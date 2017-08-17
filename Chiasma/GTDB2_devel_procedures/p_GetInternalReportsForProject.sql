USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetInternalReportsForProject]    Script Date: 11/20/2009 16:01:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_GetInternalReportsForProject]( @project_id INTEGER,
						 @identifier_filter VARCHAR(255) )

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
WHERE project_id = @project_id
AND identifier LIKE @identifier_filter

SET NOCOUNT OFF
END
