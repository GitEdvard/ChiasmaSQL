USE [GTDB2_devel]
GO
/****** Object:  Trigger [dbo].[T_aliquot_insert_update]    Script Date: 11/20/2009 15:07:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Logs insert and update operations to the aliquot table.

ALTER TRIGGER [dbo].[T_aliquot_insert_update] ON [dbo].[aliquot]
AFTER INSERT, UPDATE

AS
BEGIN
SET NOCOUNT ON

DECLARE @action CHAR(1)

IF EXISTS(SELECT * FROM deleted) SET @action = 'U' ELSE SET @action = 'I'


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
	@action,
	is_highlighted,
	aliquot_id
FROM inserted



SET NOCOUNT OFF
END
