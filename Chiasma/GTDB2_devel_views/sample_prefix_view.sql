use gtdb2_devel

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW sample_prefix_view AS
SELECT
	sample.sample_id as sample_sample_id,
	sample.individual_id AS sample_individual_id,
	sample.identifier AS sample_identifier,
	sample.sample_series_id AS sample_sample_series_id,
	sample.state_id AS sample_state_id,
	sample.external_name AS sample_external_name,
	sample.pos_x AS sample_pos_x,
	sample.pos_y AS sample_pos_y,
	sample.pos_z AS sample_pos_z,
	sample.volume_customer AS sample_volume_customer,
	sample.concentration_customer AS sample_concentration_customer,
	sample.volume_current AS sample_volume_current,
	sample.concentration_current AS sample_concentration_current,
	sample.concentration_current_device_id AS sample_concentration_current_device_id,
	sample.comment AS sample_comment,
	sample.fragment_length AS sample_fragment_length,
	sample.molar_concentration AS sample_molar_concentration,
	sample.is_highlighted AS sample_is_highlighted,
	sample.fragment_length_device_id AS sample_fragment_length_device_id,
	sample.molar_concentration_device_id AS sample_molar_concentration_device_id,
	sample.seq_state_category_id as sample_seq_state_category_id,
	sample.seq_type_category_id as sample_seq_type_category_id,
	sample.seq_application_category_id as sample_seq_application_category_id,
	sample.tag_index_id as sample_tag_index_id,
	sample.tag_index2_id as sample_tag_index2_id,
	sample.tube_id as sample_tube_id,
	sample.plate_id as sample_plate_id
FROM sample 

