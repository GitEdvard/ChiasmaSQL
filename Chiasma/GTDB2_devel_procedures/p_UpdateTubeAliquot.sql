USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdateTubeAliquot]    Script Date: 11/20/2009 16:26:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_UpdateTubeAliquot](
	@id INTEGER,
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
	@molar_concentration FLOAT = NULL,
	@fragment_length_device_id INTEGER = NULL,
	@molar_concentration_device_id INTEGER = NULL,
	@seq_state_category_id smallint = null,
	@seq_type_category_id smallint = null,
	@seq_application_category_id smallint = null,
	@tag_index_id int = null,
	@tag_index2_id int = null,
	@is_highlighted bit
)

AS
BEGIN
SET NOCOUNT ON

-- Update TubeAliquot.
UPDATE tube_aliquot SET
	state_id = @state_id,
	source_container_id = @source_container_id,
	source_container_position_x = @source_container_position_x,
	source_container_position_y = @source_container_position_y,
	source_container_position_z = @source_container_position_z,
	sample_id = @sample_id,
	concentration = @concentration,
	concentration_device_id = @concentration_device_id,
	volume = @volume,
	sample_dilute_factor = @sample_dilute_factor,
	comment = @comment,
	fragment_length = @fragment_length,
	molar_concentration = @molar_concentration,
	fragment_length_device_id = @fragment_length_device_id,
	molar_concentration_device_id = @molar_concentration_device_id,
	seq_state_category_id = @seq_state_category_id,
	seq_type_category_id = @seq_type_category_id,
	seq_application_category_id = @seq_application_category_id,
	tag_index_id = @tag_index_id,
	tag_index2_id = @tag_index2_id,
	is_highlighted = @is_highlighted
WHERE tube_aliquot_id = @id
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update tube_aliquot with id: %d', 15, 1, @id)
	RETURN
END

SET NOCOUNT OFF
END
