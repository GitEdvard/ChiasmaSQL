USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetFlowCellWellHistory]    Script Date: 11/20/2009 15:58:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_GetFlowCellWellHistory]
	(@id INTEGER,
	 @position_x INTEGER,
	 @position_y INTEGER)

AS
BEGIN
SET NOCOUNT ON

SELECT
	flow_cell_well_history.flow_cell_id AS id,
	flow_cell_well_history.position_x,
	flow_cell_well_history.position_y,
	flow_cell_well_history.source_container_id,
	flow_cell_well_history.source_container_position_x,
	flow_cell_well_history.source_container_position_y,
	flow_cell_well_history.source_container_position_z,
	flow_cell_well_history.comment,
	flow_cell_well_history.changed,
	flow_cell_well_history.authority_id,
	flow_cell_well_history.changed_action
FROM flow_cell_well_history
WHERE
	flow_cell_well_history.flow_cell_id = @id AND
	flow_cell_well_history.position_x = @position_x AND
	flow_cell_well_history.position_y = @position_y
ORDER BY flow_cell_well_history.changed ASC

SET NOCOUNT OFF
END
