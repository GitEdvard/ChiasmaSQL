use gtdb2_devel
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW pool_info_for_samples_view AS
SELECT
	pool_info_for_samples_id as id,
	tube_id,
	plate_id,
	plate_position_x,
	plate_position_y,
	concentration_current,
	concentration_current_device_id,
	concentration_customer,
	molar_concentration,
	molar_concentration_device_id,
	volume_current,
	volume_customer,
	fragment_length,
	fragment_length_device_id,
	seq_state_category_id,
	seq_type_category_id,
	seq_application_category_id,
	identifier,
	external_name,
	comment,
	pool_number,
	sample_series_id,
	state_id,
	is_highlighted,
	is_failed
FROM pool_info_for_samples

