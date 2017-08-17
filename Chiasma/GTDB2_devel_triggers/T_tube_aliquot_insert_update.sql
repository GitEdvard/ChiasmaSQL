--USE [GTDB2_devel]
--GO
/****** Object:  Trigger [dbo].[T_aliquot_insert_update]    Script Date: 11/20/2009 15:07:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Logs insert and update operations to the aliquot table.

ALTER TRIGGER [dbo].[T_tube_aliquot_insert_update] ON [dbo].[tube_aliquot]
AFTER INSERT, UPDATE

AS
BEGIN
SET NOCOUNT ON

DECLARE @action CHAR(1)

IF EXISTS(SELECT * FROM deleted) SET @action = 'U' ELSE SET @action = 'I'

INSERT INTO tube_aliquot_history
	(tube_aliquot_id,
	 state_id,
	 source_container_id,
	 source_container_position_x,
	 source_container_position_y,
	 source_container_position_z,
	 sample_id,
	 concentration,
	 concentration_device_id,
	 volume,
	 sample_dilute_factor,
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
	 pool_info_for_aliquots_id,
	 is_highlighted
)
SELECT
	tube_aliquot_id,
	state_id,
	source_container_id,
	source_container_position_x,
	source_container_position_y,
	source_container_position_z,
	sample_id,
	concentration,
	concentration_device_id,
	volume,
	sample_dilute_factor,
	comment,
	@action,
	fragment_length,
	fragment_length_device_id,
	molar_concentration,
	molar_concentration_device_id,
	seq_state_category_id,
	seq_type_category_id,
	seq_application_category_id,
	tag_index_id,
	tag_index2_id,
	pool_info_for_aliquots_id,
	is_highlighted
FROM inserted

-- UPDATE TUBE META DATA

-- Update meta data for tube-aliquot-comment, exclude tube-aliquots in pools
update tube_metadata set
	tube_aliquot_comment = i.comment
from inserted i 
inner join deleted d on i.tube_aliquot_id = d.tube_aliquot_id
inner join tube_metadata tm on i.tube_id = tm.tube_id
where isnull(i.pool_info_for_aliquots_id, -1) = -1 and ISNULL(i.tube_id, -1) > -1 
	and not ISNULL(i.comment, '###') = ISNULL(d.comment, '###')

SET NOCOUNT OFF
END
