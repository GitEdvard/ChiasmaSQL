USE [GTDB2_devel]
GO
/****** Object:  Trigger [dbo].[T_bead_chip_delete]    Script Date: 11/20/2009 15:08:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Logs delete operations to the bead_chip table.

CREATE TRIGGER [dbo].[T_bead_chip_delete] ON [dbo].[bead_chip]
AFTER DELETE

AS
BEGIN
SET NOCOUNT ON

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
	'D'
FROM deleted
	
SET NOCOUNT OFF
END

