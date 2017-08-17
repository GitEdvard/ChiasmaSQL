--USE [GTDB2_devel]
--GO
/****** Object:  Trigger [dbo].[T_pool_info_for_aliquots_delete]    Script Date: 11/20/2009 12:12:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Logs delete operations in the plate table.

ALTER TRIGGER [dbo].[T_pool_info_for_aliquots_delete] ON [dbo].[pool_info_for_aliquots]
AFTER DELETE

AS
BEGIN
SET NOCOUNT ON

INSERT INTO pool_info_for_aliquots_history
	(pool_info_for_aliquots_id,
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
	 changed_action,
	 is_highlighted,
	 is_failed,
	 pool_info_for_samples_id)
SELECT
pool_info_for_aliquots_id,
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
	 'D',
	 is_highlighted,
	 is_failed,
	 pool_info_for_samples_id
FROM deleted

-- UPDATE TUBE META DATA

update tube_metadata set
	pool_info_for_aliquot_comment = null
from deleted d inner join tube_metadata tm on d.tube_id = tm.tube_id
where ISNULL( d.tube_id, -1) > -1 and not ISNULL( d.comment, '###') = '###'

	
SET NOCOUNT OFF
END


