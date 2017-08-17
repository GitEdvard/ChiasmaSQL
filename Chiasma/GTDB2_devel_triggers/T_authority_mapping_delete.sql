USE [GTDB2_devel]
GO
/****** Object:  Trigger [dbo].[T_authority_mapping_delete]    Script Date: 11/20/2009 15:08:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER TRIGGER [dbo].[T_authority_mapping_delete] ON [dbo].[authority_mapping]
AFTER DELETE

AS
BEGIN
SET NOCOUNT ON

INSERT INTO authority_mapping_history
	(authority_group_id,
	 authority_id,
	 changed_action)
SELECT
	authority_group_id,
	authority_id,
	'D'
FROM deleted
	
SET NOCOUNT OFF
END
