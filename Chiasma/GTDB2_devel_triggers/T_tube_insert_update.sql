USE [GTDB2_devel]
GO
/****** Object:  Trigger [dbo].[T_tube_insert_update]    Script Date: 11/20/2009 15:15:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Logs insert and update operations to the tube table.

ALTER TRIGGER [dbo].[T_tube_insert_update] ON [dbo].[tube]
AFTER INSERT, UPDATE

AS
BEGIN
SET NOCOUNT ON

DECLARE @action CHAR(1)

IF EXISTS(SELECT * FROM deleted) SET @action = 'U' ELSE SET @action = 'I'

INSERT INTO tube_history
	(tube_id,
	 identifier,
	 status,
	 tube_usage,
	 comment,
	 changed_action,
	 method,
	 is_highlighted,
	 is_failed)
SELECT
	tube_id,
	identifier,
	status,
	tube_usage,
	comment,
	@action,
	method,
	is_highlighted,
	is_failed
FROM inserted
	
SET NOCOUNT OFF
END
