use gtdb2_devel
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW seq_info_view AS
SELECT
	seq_info_id as id,
	molar_concentration,
	molar_concentration_device_id,
	fragment_length,
	fragment_length_device_id,
	seq_state_category_id,
	seq_type_category_id,
	seq_application_category_id
FROM seq_info

