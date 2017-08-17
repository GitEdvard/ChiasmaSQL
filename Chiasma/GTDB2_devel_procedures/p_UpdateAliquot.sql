USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdateAliquot]    Script Date: 11/20/2009 16:26:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_UpdateAliquot](
	@plate_id INTEGER,
	@position_x INTEGER,
	@position_y INTEGER,
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
	@is_highlighted bit
)

AS
BEGIN
SET NOCOUNT ON

-- Update aliquot.
UPDATE aliquot SET
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
	is_highlighted = @is_highlighted
WHERE plate_id = @plate_id AND position_x = @position_x AND position_y = @position_y
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update aliquot with id: %d', 15, 1, @plate_id)
	RETURN
END

SET NOCOUNT OFF
END
