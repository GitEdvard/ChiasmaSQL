use gtdb2_devel
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW pool_info_for_aliquots_prefix_view AS
SELECT
	pool_info_for_aliquots_id as pifa_id,
	tube_id as pifa_tube_id,
	plate_id as pifa_plate_id,
	plate_position_x as pifa_plate_position_x,
	plate_position_y as pifa_plate_position_y,
	concentration as pifa_concentration,
	concentration_device_id as pifa_concentration_device_id,
	molar_concentration as pifa_molar_concentration,
	molar_concentration_device_id as pifa_molar_concentration_device_id,
	volume as pifa_volume,
	fragment_length as pifa_fragment_length,
	fragment_length_device_id as pifa_fragment_length_device_id,
	seq_state_category_id as pifa_seq_state_category_id,
	seq_type_category_id as pifa_seq_type_category_id,
	seq_application_category_id as pifa_seq_application_category_id,
	identifier as pifa_identifier,
	comment as pifa_comment,
	pool_number as pifa_pool_number,
	sample_series_id as pifa_sample_series_id,
	state_id as pifa_state_id,
	is_highlighted as pifa_is_highlighted,
	is_failed as pifa_is_failed,
	created_date as pifa_created_date,
	pool_info_for_samples_id as pifa_pool_info_for_samples_id
FROM pool_info_for_aliquots

