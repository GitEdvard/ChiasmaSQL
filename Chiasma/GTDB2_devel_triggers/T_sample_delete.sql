--USE [GTDB2_devel]
--GO
/****** Object:  Trigger [dbo].[T_sample_delete]    Script Date: 11/20/2009 15:14:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Logs delete operations in the sample table.

ALTER TRIGGER [dbo].[T_sample_delete] ON [dbo].[sample]
AFTER DELETE

AS
BEGIN
SET NOCOUNT ON

INSERT INTO sample_history
	(sample_id,
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
	 pool_info_for_samples_id,
	 tube_id,
	 plate_id
)
SELECT
	sample_id,
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
	'D',
	 fragment_length,
	 fragment_length_device_id,
	 molar_concentration,
	 molar_concentration_device_id,
	 seq_state_category_id,
	 seq_type_category_id,
	 seq_application_category_id,
	 tag_index_id,
	 tag_index2_id,
	 pool_info_for_samples_id,
	 tube_id,
	 plate_id
FROM deleted

--UPDATE TUBE META DATA
-- UPDATE TUBE-META DATA FOR MASTER TUBES
update tube_metadata set
	sample_comment = NULL
from deleted d
inner join tube_metadata tm on d.tube_id = tm.tube_id
where isnull(d.tube_id, -1) > -1 and not ISNULL(d.comment, '###') = '###'

-- UPDATE TUBE-META DATA FOR ALIQUOT TUBES (should not happen)
update tube_metadata set
	sample_comment = NULL
from deleted d
inner join tube_aliquot ta on d.sample_id = ta.sample_id
inner join tube_metadata tm on ta.tube_id = tm.tube_id
where isnull(ta.pool_info_for_aliquots_id, -1) = -1 and not ISNULL(d.comment, '###') = '###'

	
SET NOCOUNT OFF
END
