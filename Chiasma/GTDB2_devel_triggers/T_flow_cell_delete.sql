USE [GTDB2_devel]
GO
/****** Object:  Trigger [dbo].[T_flow_cell_delete]    Script Date: 11/20/2009 15:10:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Logs delete operations to the flow_cell table.

ALTER TRIGGER [dbo].[T_flow_cell_delete] ON [dbo].[flow_cell]
AFTER DELETE

AS
BEGIN
SET NOCOUNT ON

INSERT INTO flow_cell_history
	(flow_cell_id,
	 identifier,
	 bead_chip_type_id,
	 status,
	 comment,
	 changed_action)
SELECT
	flow_cell_id,
	identifier,
	bead_chip_type_id,
	status,
	comment,
	'D'
FROM deleted
	
SET NOCOUNT OFF
END
