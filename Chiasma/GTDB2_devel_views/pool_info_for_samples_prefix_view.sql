use gtdb2_devel
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW pool_info_for_samples_prefix_view AS
SELECT
	pool_info_for_samples_id as pifs_id,
	identifier as pifs_identifier,
	sample_series_id as pifs_sample_series_id,
	state_id as pifs_state_id,
	external_name as pifs_external_name,
	tube_id as pifs_tube_id,
	plate_id as pifs_plate_id,
	plate_position_x as pifs_plate_position_x,
	plate_position_y as pifs_plate_position_y,
	volume_customer as pifs_volume_customer,
	concentration_customer as pifs_concentration_customer,
	volume_current as pifs_volume_current,
	concentration_current as pifs_concentration_current,
	concentration_current_device_id as pifs_concentration_current_device_id,
	comment as pifs_comment,
	molar_concentration as pifs_molar_concentration,
	fragment_length as pifs_fragment_length,
	fragment_length_device_id as pifs_fragment_length_device_id,
	molar_concentration_device_id as pifs_molar_concentration_device_id,
	seq_state_category_id as pifs_seq_state_category_id,
	seq_type_category_id as pifs_seq_type_category_id,
	seq_application_category_id as pifs_seq_application_category_id,
	pool_number as pifs_pool_number,
	is_failed as pifs_is_failed,
	is_highlighted as pifs_is_highlighted
FROM pool_info_for_samples

