USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdatePoolInfoForSamples]    Script Date: 11/20/2009 16:30:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_UpdatePoolInfoForSamples](
	@id INTEGER,
	@concentration_current float = null,
	@concentration_current_device_id int = null,
	@concentration_customer float = null,
	@molar_concentration float = null,
	@molar_concentration_device_id int = null,
	@volume_current float = null,
	@volume_customer float = null,
	@fragment_length int = null,
	@fragment_length_device_id int = null,
	@seq_state_category_id int = null,
	@seq_type_category_id int = null,
	@seq_application_category_id int = null,
	@identifier varchar(255) = null,
	@external_name varchar(255) = null,
	@comment varchar(1024) = null,
	@pool_number int = null,
	@sample_series_id int = null,
	@state_id int = null,
	@is_highlighted bit,
	@is_failed bit
)

AS
BEGIN
SET NOCOUNT ON

update pool_info_for_samples set
concentration_current = @concentration_current,
concentration_current_device_id = @concentration_current_device_id,
concentration_customer = @concentration_customer,
molar_concentration = @molar_concentration,
molar_concentration_device_id = @molar_concentration_device_id,
volume_current = @volume_current,
volume_customer = @volume_customer,
fragment_length = @fragment_length,
fragment_length_device_id = @fragment_length_device_id,
seq_state_category_id = @seq_state_category_id,
seq_type_category_id = @seq_type_category_id,
seq_application_category_id = @seq_application_category_id,
identifier = @identifier,
external_name = @external_name,
comment = @comment,
pool_number = @pool_number,
sample_series_id = @sample_series_id,
state_id = @state_id,
is_highlighted = @is_highlighted,
is_failed = @is_failed
where pool_info_for_samples_id = @id

IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update pool info for aliquots with id: %d', 15, 1, @id)
	RETURN
END

SET NOCOUNT OFF
END
