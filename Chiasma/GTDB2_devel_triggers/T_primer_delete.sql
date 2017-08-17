USE [GTDB2_devel]
GO
/****** Object:  Trigger [dbo].[T_primer_delete]    Script Date: 11/20/2009 15:13:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[T_primer_delete] ON [dbo].[primer]
AFTER DELETE

AS
BEGIN
SET NOCOUNT ON

INSERT INTO primer_history
	(primer_id,
	 identifier,
	 type,
	 sequence_str,
	 orientation,
	 modification,
	 comment,
	 changed_action)
SELECT
	primer_id,
	identifier,
	type,
	sequence_str,
	orientation,
	modification,
	comment,
	'D'
FROM deleted
	
SET NOCOUNT OFF
END
