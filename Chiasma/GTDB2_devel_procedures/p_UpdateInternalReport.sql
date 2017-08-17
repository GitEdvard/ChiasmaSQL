USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdateInternalReport]    Script Date: 11/20/2009 16:27:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_UpdateInternalReport](
	@id INTEGER,
	@identifier VARCHAR(255),
	@comment VARCHAR(512) = NULL,
	@uploading_flag bit)

AS
BEGIN
SET NOCOUNT ON

-- Update sample.
UPDATE internal_report SET
	identifier = @identifier,
	comment = @comment,
	uploading_flag = @uploading_flag
WHERE internal_report_id = @id

IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update internal report with id: %d', 15, 1, @id)
	RETURN
END

SET NOCOUNT OFF
END
