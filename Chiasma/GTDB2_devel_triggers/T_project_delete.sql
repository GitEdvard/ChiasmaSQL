USE [GTDB2_devel]
GO
/****** Object:  Trigger [dbo].[T_project_delete]    Script Date: 11/20/2009 15:14:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[T_project_delete] ON [dbo].[project]
AFTER DELETE

AS
BEGIN
SET NOCOUNT ON

INSERT INTO project_history
	(project_id,
	 identifier,
	 comment,
	 changed_action)
SELECT
	project_id,
	identifier,
	comment,
	'D'
FROM deleted
	
SET NOCOUNT OFF
END


	

