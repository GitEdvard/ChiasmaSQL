use gtdb2_devel
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW pool_info_for_aliquots_view AS
SELECT
	pool_info_for_aliquots_id as id,
	tube_id,
	plate_id,
	plate_position_x,
	plate_position_y,
	concentration,
	concentration_device_id,
	molar_concentration,
	molar_concentration_device_id,
	volume,
	fragment_length,
	fragment_length_device_id,
	seq_state_category_id,
	seq_type_category_id,
	seq_application_category_id,
	identifier,
	comment,
	pool_number,
	sample_series_id,
	state_id,
	is_highlighted,
	is_failed,
	created_date,
	pool_info_for_samples_id
FROM pool_info_for_aliquots

