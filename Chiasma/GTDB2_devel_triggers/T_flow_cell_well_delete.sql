USE [GTDB2_devel]
GO
/****** Object:  Trigger [dbo].[T_flow_cell_well_delete]    Script Date: 11/20/2009 15:11:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Logs insert and update operations to the flow_cell table.

ALTER TRIGGER [dbo].[T_flow_cell_well_delete] ON [dbo].[flow_cell_well]
AFTER DELETE

AS
BEGIN
SET NOCOUNT ON

DECLARE @action CHAR(1)

SET @action = 'D'

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
		 d.flow_cell_well_id,
		 d.flow_cell_id,
		 d.position_x,
		 d.position_y,
		 d.source_container_id,
		 d.source_container_position_x,
		 d.source_container_position_y,
		 d.comment,
		 @action
	FROM deleted d

	
SET NOCOUNT OFF
END
