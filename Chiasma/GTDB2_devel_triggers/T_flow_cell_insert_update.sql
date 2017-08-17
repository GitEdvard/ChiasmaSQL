USE [GTDB2_devel]
GO
/****** Object:  Trigger [dbo].[T_flow_cell_insert_update]    Script Date: 11/20/2009 15:10:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Logs insert and update operations to the flow_cell table.

ALTER TRIGGER [dbo].[T_flow_cell_insert_update] ON [dbo].[flow_cell]
AFTER INSERT, UPDATE

AS
BEGIN
SET NOCOUNT ON

DECLARE @action CHAR(1)

IF EXISTS(SELECT * FROM deleted) SET @action = 'U' ELSE SET @action = 'I'

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
	@action
FROM inserted
	
SET NOCOUNT OFF
END
