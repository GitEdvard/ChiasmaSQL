use gtdb2_devel
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
alter view tube_aliquot_history_view as
SELECT
	tah.tube_aliquot_id,
	tah.state_id,
	tah.source_container_id,
	tah.source_container_position_x,
	tah.source_container_position_y,
	tah.source_container_position_z,
	tah.sample_id,
	tah.concentration,
	tah.concentration_device_id,
	tah.volume,
	tah.sample_dilute_factor,
	tah.comment,
	tah.changed_date,
	tah.changed_authority_id,
	tah.changed_action,
	tah.fragment_length,
	tah.fragment_length_device_id,
	tah.molar_concentration,
	tah.molar_concentration_device_id,
	tah.seq_state_category_id,
	tah.seq_type_category_id,
	tah.seq_application_category_id,
	tah.tag_index_id,
	tah.tag_index2_id,
	tah.pool_info_for_aliquots_id,
	tah.is_highlighted
FROM tube_aliquot_history tah
