--USE [GTDB2_devel]
--GO
/****** Object:  Trigger [dbo].[T_pool_info_for_aliquots_insert_update]    Script Date: 11/20/2009 15:13:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Logs insert and update operations to the plate table.

ALTER TRIGGER [dbo].[T_pool_info_for_aliquots_insert_update] ON [dbo].[pool_info_for_aliquots]
AFTER INSERT, UPDATE

AS
BEGIN
SET NOCOUNT ON

DECLARE @action CHAR(1)

IF EXISTS(SELECT * FROM deleted) SET @action = 'U' ELSE SET @action = 'I'

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
     @action,
	 is_highlighted,
	 is_failed,
	 pool_info_for_samples_id
FROM inserted

-- UPDATE TUBE META DATA
update tube_metadata set
	pool_info_for_aliquot_comment = i.comment
from deleted d
inner join inserted i on i.pool_info_for_aliquots_id = d.pool_info_for_aliquots_id
inner join tube_metadata tm on i.tube_id = tm.tube_id
where isnull(i.tube_id, -1) > -1 and not ISNULL( i.comment, '###') = ISNULL( d.comment, '###')

SET NOCOUNT OFF
END
