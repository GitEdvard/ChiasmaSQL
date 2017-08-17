USE [GTDB2_devel]
GO
/****** Object:  Trigger [dbo].[T_aliquot_delete]    Script Date: 11/20/2009 15:07:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Logs delete operations in the aliquot table.

ALTER TRIGGER [dbo].[T_aliquot_delete] ON [dbo].[aliquot]
AFTER DELETE

AS
BEGIN
SET NOCOUNT ON

INSERT INTO aliquot_history
	(plate_id,
	 position_x,
	 position_y,
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
	 is_highlighted,
	 aliquot_id)
SELECT
	plate_id,
	position_x,
	position_y,
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
	'D',
	 is_highlighted,
	 aliquot_id
FROM deleted

SET NOCOUNT OFF
END








