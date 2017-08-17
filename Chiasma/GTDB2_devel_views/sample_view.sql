use gtdb2_devel
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW sample_view AS
SELECT 
	s.sample_id AS id,
	s.individual_id,
	s.identifier,
	s.sample_series_id,
	s.state_id,
	s.external_name,
	s.pos_x,
	s.pos_y,
	s.pos_z,
	s.volume_customer,
	s.concentration_customer,
	s.volume_current,
	s.concentration_current,
	s.concentration_current_device_id,
	s.comment,
	s.fragment_length,
	s.molar_concentration,
	s.is_highlighted,
	s.fragment_length_device_id,
	s.molar_concentration_device_id,
	s.seq_state_category_id,
	s.seq_type_category_id,
	s.seq_application_category_id,
	s.tag_index_id,
	s.tag_index2_id,
	s.pool_info_for_samples_id,
	s.tube_id,
	s.plate_id
FROM sample s
