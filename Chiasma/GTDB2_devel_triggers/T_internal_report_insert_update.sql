USE [GTDB2_devel]
GO
/****** Object:  Trigger [dbo].[T_internal_report_insert_update]    Script Date: 11/20/2009 15:12:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Logs insert and update operations in the internal_report table.

ALTER TRIGGER [dbo].[T_internal_report_insert_update] ON [dbo].[internal_report]
AFTER INSERT, UPDATE

AS
BEGIN
SET NOCOUNT ON

DECLARE @action CHAR(1)

IF EXISTS(SELECT * FROM deleted) SET @action = 'U' ELSE SET @action = 'I'

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
	@action
FROM inserted
	
SET NOCOUNT OFF
END
