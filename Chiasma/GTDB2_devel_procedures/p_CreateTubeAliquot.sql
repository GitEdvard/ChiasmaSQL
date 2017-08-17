USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreateTubeAliquot]    Script Date: 11/16/2009 13:35:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_CreateTubeAliquot](
	@tube_id INTEGER = null,
	@state_id SMALLINT,
	@source_container_id INTEGER = NULL,
	@source_container_position_x INTEGER = NULL,
	@source_container_position_y INTEGER = NULL,
	@source_container_position_z INTEGER = NULL,
	@sample_id INTEGER = NULL,
	@concentration FLOAT = NULL,
	@concentration_device_id INTEGER = NULL,
	@volume FLOAT = NULL,
	@sample_dilute_factor FLOAT = NULL,
	@comment VARCHAR(1024) = NULL,
	@fragment_length INTEGER = NULL,
	@fragment_length_device_id INTEGER = NULL,
	@molar_concentration FLOAT = NULL,
	@molar_concentration_device_id INTEGER = NULL,
	@seq_state_category_id smallint = null,
	@seq_type_category_id smallint = null,
	@seq_application_category_id smallint = null,
	@plate_id int = null,
	@position_x int = null,
	@position_y int = null,
	@tag_index_id int = null,
	@tag_index2_id int = null,
	@pool_info_for_aliquots_id int = null,
	@is_highlighted bit
)

AS
BEGIN
SET NOCOUNT ON

DECLARE @tube_aliquot_id INTEGER
-- Create device.
INSERT INTO tube_aliquot 
(
	tube_id,
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
	fragment_length,
	molar_concentration,
	fragment_length_device_id,
	molar_concentration_device_id,
	seq_state_category_id,
	seq_type_category_id,
	seq_application_category_id,
	plate_id,
	position_x,
	position_y,
	tag_index_id,
	tag_index2_id,
	pool_info_for_aliquots_id,
	is_highlighted
) 
VALUES 
(
	@tube_id,
	@state_id,
	@source_container_id,
	@source_container_position_x,
	@source_container_position_y,
	@source_container_position_z,
	@sample_id,
	@concentration,
	@concentration_device_id,
	@volume,
	@sample_dilute_factor,
	@comment,
	@fragment_length,
	@molar_concentration,
	@fragment_length_device_id,
	@molar_concentration_device_id,
	@seq_state_category_id,
	@seq_type_category_id,
	@seq_application_category_id,
	@plate_id,
	@position_x,
	@position_y,
	@tag_index_id,
	@tag_index2_id,
	@pool_info_for_aliquots_id,
	@is_highlighted
)
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to create tube aliquot from source tube_id: %s', 15, 1, @tube_id)
	RETURN
END

SET @tube_aliquot_id = SCOPE_IDENTITY()

SELECT * FROM tube_aliquot_sample_view 
WHERE id = @tube_aliquot_id



SET NOCOUNT OFF
END

