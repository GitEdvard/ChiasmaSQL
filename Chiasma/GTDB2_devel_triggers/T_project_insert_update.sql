USE [GTDB2_devel]
GO
/****** Object:  Trigger [dbo].[T_project_insert_update]    Script Date: 11/20/2009 15:14:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[T_project_insert_update] ON [dbo].[project]
AFTER INSERT, UPDATE

AS
BEGIN
SET NOCOUNT ON

DECLARE @action CHAR(1)

IF EXISTS(SELECT * FROM deleted) SET @action = 'U' ELSE SET @action = 'I'

INSERT INTO project_history
	(project_id,
	 identifier,
	 comment,
	 changed_action)
SELECT
	project_id,
	identifier,
	comment,
	@action
FROM inserted
	
SET NOCOUNT OFF
END


	

