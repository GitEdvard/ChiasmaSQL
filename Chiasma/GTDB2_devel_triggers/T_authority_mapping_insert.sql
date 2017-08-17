USE [GTDB2_devel]
GO
/****** Object:  Trigger [dbo].[T_authority_mapping_insert]    Script Date: 11/20/2009 15:08:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[T_authority_mapping_insert] ON [dbo].[authority_mapping]
AFTER INSERT

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
	'I'
FROM inserted
	
SET NOCOUNT OFF
END
