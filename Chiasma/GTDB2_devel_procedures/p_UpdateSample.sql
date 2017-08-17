USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdateSample]    Script Date: 11/20/2009 16:29:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_UpdateSample](
	@id INTEGER,
	@identifier VARCHAR(255),
	@sample_series_id INTEGER,
	@individual_id INTEGER,
	@state_id SMALLINT,
	@external_name VARCHAR(255) = NULL,
	@pos_x INTEGER = NULL,
	@pos_y INTEGER = NULL,
	@pos_z INTEGER = NULL,
	@concentration_current FLOAT = NULL,
	@concentration_current_device_id INTEGER = NULL,
	@concentration_customer FLOAT = NULL,
	@volume_current FLOAT = NULL,
	@volume_customer FLOAT = NULL,
	@comment VARCHAR(1024) = NULL,
	@is_highlighted BIT = NULL,
	@molar_concentration varchar(50) = null,
	@molar_concentration_device_id int = null,
	@fragment_length int = null,
	@fragment_length_device_id int = null,
	@seq_state_category_id smallint = null,
	@seq_type_category_id smallint = null,
	@seq_application_category_id smallint = null,
	@tag_index_id int = null,
	@tag_index2_id int = null,
	@tube_id int = null,
	@plate_id int = null)

AS
BEGIN
SET NOCOUNT ON

-- Update sample.
UPDATE sample SET
	identifier = @identifier,
	sample_series_id = @sample_series_id,
	individual_id = @individual_id,
	state_id = @state_id,
	external_name = @external_name,
	pos_x = @pos_x,
	pos_y = @pos_y,
	pos_z = @pos_z,
	concentration_current = @concentration_current,
	concentration_current_device_id = @concentration_current_device_id,
	concentration_customer = @concentration_customer,
	volume_current = @volume_current,
	volume_customer = @volume_customer,
	comment = @comment,
	is_highlighted = @is_highlighted,
	seq_state_category_id = @seq_state_category_id,
	seq_type_category_id = @seq_type_category_id,
	seq_application_category_id = @seq_application_category_id,
	molar_concentration = @molar_concentration,
	molar_concentration_device_id = @molar_concentration_device_id,
	fragment_length = @fragment_length,
	fragment_length_device_id = @fragment_length_device_id,
	tag_index_id = @tag_index_id,
	tag_index2_id = @tag_index2_id,
	tube_id = @tube_id,
	plate_id = @plate_id

WHERE sample_id = @id
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update sample with id: %d', 15, 1, @id)
	RETURN
END

SET NOCOUNT OFF
END
