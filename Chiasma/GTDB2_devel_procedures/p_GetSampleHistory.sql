USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetSampleHistory]    Script Date: 11/20/2009 16:06:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_GetSampleHistory]( @id INTEGER )

AS
BEGIN
SET NOCOUNT ON

SELECT 
	sample_id AS id,
	individual_id,
	identifier,
	sample_series_id,
	state_id,
	external_name,
	pos_x,
	pos_y,
	pos_z,
	volume_customer,
	concentration_customer,
	volume_current,
	concentration_current,
	concentration_current_device_id,
	comment,
	changed_date,
	changed_authority_id,
	changed_action,
	fragment_length,
	fragment_length_device_id,
	molar_concentration,
	molar_concentration_device_id,
	seq_state_category_id,
	seq_type_category_id,
	seq_application_category_id,
	tag_index_id,
	tag_index2_id,
	tube_id,
	plate_id
FROM sample_history
WHERE sample_id = @id
ORDER BY changed_date ASC

SET NOCOUNT OFF
END
