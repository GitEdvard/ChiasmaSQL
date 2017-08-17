USE [GTDB2_devel]
GO
/****** Object:  Trigger [dbo].[T_pool_info_for_samples_delete]    Script Date: 11/20/2009 15:13:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Logs insert and update operations to the plate table.

CREATE TRIGGER [dbo].[T_pool_info_for_samples_delete] ON [dbo].[pool_info_for_samples]
AFTER DELETE

AS
BEGIN
SET NOCOUNT ON

INSERT INTO pool_info_for_samples_history
	(pool_info_for_samples_id,
	 tube_id,
	 plate_id,	
	 plate_position_x,
	 plate_position_y,
	 external_name,
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
	 comment,
	 pool_number,
	 sample_series_id,
	 state_id,
	 changed_action,
	 is_highlighted,
	 is_failed)
SELECT
pool_info_for_samples_id,
	 tube_id,
	 plate_id,	
	 plate_position_x,
	 plate_position_y,
	 external_name,
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
	 comment,
	 pool_number,
	 sample_series_id,
	 state_id,
	 'D',
	 is_highlighted,
	 is_failed
FROM deleted
	
SET NOCOUNT OFF
END