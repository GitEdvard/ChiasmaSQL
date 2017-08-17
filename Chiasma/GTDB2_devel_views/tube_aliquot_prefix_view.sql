use gtdb2_devel
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW tube_aliquot_prefix_view AS
SELECT
	ta.tube_aliquot_id as ta_id,
	ta.tube_id as ta_tube_id,
	ta.state_id as ta_state_id,
	ta.source_container_id as ta_source_container_id,
	ta.source_container_position_x as ta_source_container_position_x,
	ta.source_container_position_y as ta_source_container_position_y,
	ta.source_container_position_z as ta_source_container_position_z,
	ta.sample_id as ta_sample_id,
	ta.concentration as ta_concentration,
	ta.concentration_device_id as ta_concentration_device_id,
	ta.volume as ta_volume,
	ta.sample_dilute_factor as ta_sample_dilute_factor,
	ta.comment as ta_comment,
	ta.molar_concentration as ta_molar_concentration,
	ta.fragment_length as ta_fragment_length,
	ta.fragment_length_device_id as ta_fragment_length_device_id,
	ta.molar_concentration_device_id as ta_molar_concentration_device_id,
	ta.seq_state_category_id as ta_seq_state_category_id,
	ta.seq_type_category_id as ta_seq_type_category_id,
	ta.seq_application_category_id as ta_seq_application_category_id,
	ta.plate_id as ta_plate_id,
	ta.position_x as ta_position_x,
	ta.position_y as ta_position_y,
	ta.tag_index_id as ta_tag_index_id,
	ta.tag_index2_id as ta_tag_index2_id,
	ta.pool_info_for_aliquots_id as ta_pool_info_for_aliquots_id,
	ta.is_highlighted as ta_is_highlighted,
	ac.identifier as ta_source_container_identifier
FROM tube_aliquot ta 
left outer join all_containers ac on ta.source_container_id = ac.generic_container_id

