USE [GTDB2_devel]
GO
/****** Object:  Trigger [dbo].[T_internal_report_delete]    Script Date: 11/20/2009 15:12:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Logs delete operations in the internal_report table.

ALTER TRIGGER [dbo].[T_internal_report_delete] ON [dbo].[internal_report]
AFTER DELETE

AS
BEGIN
SET NOCOUNT ON

INSERT INTO internal_report_history
	(internal_report_id,
	 identifier,
	 authority_id,
	 project_id,
	 source,
	 is_bulk,
	 uploading_flag,
	 comment,
	 changed_action)
SELECT
	internal_report_id,
	identifier,
	authority_id,
	project_id,
	source,
	is_bulk,
	uploading_flag,
	comment,
	'D'
FROM deleted
	
SET NOCOUNT OFF
END
