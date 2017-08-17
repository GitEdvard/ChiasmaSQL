use gtdb2_devel
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW tube_aliquot_view AS
SELECT
	ta.tube_aliquot_id AS id,
	ta.tube_id,
	ta.state_id,
	ta.source_container_id,
	ta.source_container_position_x,
	ta.source_container_position_y,
	ta.source_container_position_z,
	ta.sample_id,
	ta.concentration,
	ta.concentration_device_id,
	ta.volume,
	ta.sample_dilute_factor,
	ta.comment,
	ta.molar_concentration,
	ta.fragment_length,
	ta.fragment_length_device_id,
	ta.molar_concentration_device_id,
	ta.seq_state_category_id,
	ta.seq_type_category_id,
	ta.seq_application_category_id,
	ta.plate_id,
	ta.position_x,
	ta.position_y,
	ta.tag_index_id,
	ta.tag_index2_id,
	ta.pool_info_for_aliquots_id,
	ta.is_highlighted,
	ac.identifier as source_container_identifier
FROM tube_aliquot ta 
left outer join all_containers ac on ta.source_container_id = ac.generic_container_id

