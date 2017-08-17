USE [GTDB2_devel]
GO
/****** Object:  Trigger [dbo].[T_bead_chip_insert_update]    Script Date: 11/20/2009 15:09:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Logs insert and update operations to the bead_chip table.

CREATE TRIGGER [dbo].[T_bead_chip_insert_update] ON [dbo].[bead_chip]
AFTER INSERT, UPDATE

AS
BEGIN
SET NOCOUNT ON

DECLARE @action CHAR(1)

IF EXISTS(SELECT * FROM deleted) SET @action = 'U' ELSE SET @action = 'I'

INSERT INTO bead_chip_history
	(bead_chip_id,
	 identifier,
	 bead_chip_type_id,
	 status,
	 comment,
	 changed_action)
SELECT
	bead_chip_id,
	identifier,
	bead_chip_type_id,
	status,
	comment,
	@action
FROM inserted
	
SET NOCOUNT OFF
END
