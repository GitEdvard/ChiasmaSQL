USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdateInternalReportMarkerComment]    Script Date: 11/20/2009 16:27:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_UpdateInternalReportMarkerComment](
	@internal_report_id INTEGER,
	@marker_id INTEGER,
	@comment VARCHAR(1024) = NULL)

AS
BEGIN
SET NOCOUNT ON

-- Update marker comment for the internal report.
UPDATE internal_report_marker_stat SET
	comment = @comment
WHERE internal_report_id = @internal_report_id AND marker_id = @marker_id
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update marker comment for internal report with id: %d', 15, 1, @internal_report_id)
	RETURN
END

SET NOCOUNT OFF

END
