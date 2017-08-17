USE [GTDB2_devel]
GO
/****** Object:  Trigger [dbo].[T_tube_delete]    Script Date: 11/20/2009 15:15:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Logs delete operations in the tube table.

ALTER TRIGGER [dbo].[T_tube_delete] ON [dbo].[tube]
AFTER DELETE

AS
BEGIN
SET NOCOUNT ON

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
	'D',
	method,
	is_highlighted,
	is_failed
FROM deleted
	
SET NOCOUNT OFF
END
