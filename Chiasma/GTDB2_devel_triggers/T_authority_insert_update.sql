USE [GTDB2_devel]
GO
/****** Object:  Trigger [dbo].[T_authority_insert_update]    Script Date: 11/20/2009 15:08:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Logs insert and update operations in the authority table.

CREATE TRIGGER [dbo].[T_authority_insert_update] ON [dbo].[authority]
AFTER INSERT, UPDATE

AS
BEGIN
SET NOCOUNT ON

DECLARE @action CHAR(1)

IF EXISTS(SELECT * FROM deleted) SET @action = 'U' ELSE SET @action = 'I'

INSERT INTO authority_history
	(authority_id,
	 identifier,
	 name,
	 user_type,
	 account_status,
	 comment,
	 changed_action)
SELECT
	 authority_id,
	 identifier,
	 name,
	 user_type,
	 account_status,
	 comment,
	 @action
FROM inserted
	
SET NOCOUNT OFF
END
