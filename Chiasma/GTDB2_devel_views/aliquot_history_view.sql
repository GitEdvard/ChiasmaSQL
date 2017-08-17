use gtdb2_devel
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
alter view aliquot_history_view as
SELECT
	sh.plate_id,
	sh.position_x,
	sh.position_y,
	sh.state_id,
	sh.source_container_id,
	sh.source_container_position_x,
	sh.source_container_position_y,
	sh.source_container_position_z,
	sh.sample_id,
	sh.concentration,
	sh.concentration_device_id,
	sh.volume,
	sh.sample_dilute_factor,
	sh.comment,
	sh.changed_date,
	sh.changed_authority_id,
	sh.changed_action,
	sh.is_highlighted,
	sh.aliquot_id
FROM aliquot_history sh
