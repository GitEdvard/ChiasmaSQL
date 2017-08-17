USE [GTDB2_devel]
GO
/****** Object:  Trigger [dbo].[T_primer_insert_update]    Script Date: 11/20/2009 15:13:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[T_primer_insert_update] ON [dbo].[primer]
AFTER INSERT, UPDATE

AS
BEGIN
SET NOCOUNT ON

DECLARE @action CHAR(1)

IF EXISTS(SELECT * FROM deleted) SET @action = 'U' ELSE SET @action = 'I'

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
	@action
FROM inserted
	
SET NOCOUNT OFF
END
