USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreatePoolInfoForSamples]    Script Date: 11/16/2009 13:40:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[p_CreatePoolInfoForSamples](
	@tube_id int = null,
	@plate_id int = null,
	@plate_position_x int = null,
	@plate_position_y int = null,
	@concentration_current float = null,
	@concentration_current_device_id int = null,
	@concentration_customer float = null,
	@molar_concentration float = null,
	@molar_concentration_device_id int = null,
	@volume_customer float = null,
	@volume_current float = null,
	@fragment_length int = null,
	@fragment_length_device_id int = null,
	@seq_state_category_id int = null,
	@seq_type_category_id int = null,
	@seq_application_category_id int = null,
	@identifier varchar(255) = null,
	@pool_number int = null,
	@sample_series_id int = null,
	@state_id int = null,
	@comment varchar(1024) = null,
	@is_highlighted bit,
	@is_failed bit,
	@external_name varchar(255) = null
)

AS
BEGIN
SET NOCOUNT ON

-- Create pool_info.
INSERT into pool_info_for_samples
	(tube_id,
	 plate_id,
	 plate_position_x,
	 plate_position_y,
	 concentration_current,
	 concentration_current_device_id,
	 concentration_customer,
	 molar_concentration,
	 molar_concentration_device_id,
	 volume_current,
	 volume_customer,
	 fragment_length,
	 fragment_length_device_id,
	 seq_state_category_id,
	 seq_type_category_id,
	 seq_application_category_id,
	 identifier,
	 external_name,
	 comment,
	 pool_number,
	 sample_series_id,
	 state_id,
	 is_highlighted)
VALUES
	(@tube_id,
	 @plate_id,
	 @plate_position_x,
	 @plate_position_y,
	 @concentration_current,
	 @concentration_current_device_id,
	 @concentration_customer,
	 @molar_concentration,
	 @molar_concentration_device_id,
	 @volume_current,
	 @volume_customer,
	 @fragment_length,
	 @fragment_length_device_id,
	 @seq_state_category_id,
	 @seq_type_category_id,
	 @seq_application_category_id,
	 @identifier,
	 @external_name,
	 @comment,
	 @pool_number,
	 @sample_series_id,
	 @state_id,
	 @is_highlighted)

IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to create pool info for samples', 15, 1)
	RETURN
END

SELECT * from pool_info_for_samples_view
where id = scope_identity()

SET NOCOUNT OFF
END
