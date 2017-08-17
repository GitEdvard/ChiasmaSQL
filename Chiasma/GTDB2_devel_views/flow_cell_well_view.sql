use gtdb2_devel

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW flow_cell_well_view AS
SELECT
	flow_cell_well.flow_cell_well_id as id,
	flow_cell_well.flow_cell_id,
	flow_cell_well.position_x,
	flow_cell_well.position_y,
	flow_cell_well.source_container_id,
	flow_cell_well.source_container_position_x,
	flow_cell_well.source_container_position_y,
	flow_cell_well.source_container_position_z,
	flow_cell_well.comment
FROM flow_cell_well
