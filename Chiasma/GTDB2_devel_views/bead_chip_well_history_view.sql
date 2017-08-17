use gtdb2_devel

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW bead_chip_well_history_view AS
SELECT
	bead_chip_well_history.bead_chip_id AS id,
	bead_chip_well_history.position_x,
	bead_chip_well_history.position_y,
	bead_chip_well_history.source_container_id,
	bead_chip_well_history.source_container_position_x,
	bead_chip_well_history.source_container_position_y,
	bead_chip_well_history.source_container_position_z,
	bead_chip_well_history.sample_id,
	bead_chip_well_history.comment,
	bead_chip_well_history.changed,
	bead_chip_well_history.authority_id
FROM bead_chip_well_history
