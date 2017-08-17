USE [GTDB2_devel]
GO
/****** Object:  Trigger [dbo].[T_flow_cell_well_insert_update]    Script Date: 11/20/2009 15:11:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Logs insert and update operations to the flow_cell table.

ALTER TRIGGER [dbo].[T_flow_cell_well_insert_update] ON [dbo].[flow_cell_well]
AFTER INSERT, UPDATE

AS
BEGIN
SET NOCOUNT ON

DECLARE @action CHAR(1)

IF EXISTS(SELECT * FROM deleted) SET @action = 'U' ELSE SET @action = 'I'


INSERT INTO flow_cell_well_history
	(flow_cell_well_id,
	 flow_cell_id,
	 position_x,
	 position_y,
	 source_container_id,
	 source_container_position_x,
	 source_container_position_y,
	 comment,
	 changed_action)
SELECT
	 i.flow_cell_well_id,
	 i.flow_cell_id,
	 i.position_x,
	 i.position_y,
	 i.source_container_id,
	 i.source_container_position_x,
	 i.source_container_position_y,
	 i.comment,
	 @action
FROM inserted i
	
SET NOCOUNT OFF
END
