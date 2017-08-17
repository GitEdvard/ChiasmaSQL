use gtdb2_devel

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW bead_chip_well_view AS
SELECT
	bead_chip_well.bead_chip_id AS id,
	bead_chip_well.position_x,
	bead_chip_well.position_y,
	bead_chip_well.source_container_id,
	bead_chip_well.source_container_position_x,
	bead_chip_well.source_container_position_y,
	bead_chip_well.source_container_position_z,
	bead_chip_well.sample_id,
	bead_chip_well.comment,
	spv.*
FROM bead_chip_well
LEFT OUTER JOIN sample_prefix_view spv
ON spv.sample_sample_id = bead_chip_well.sample_id
