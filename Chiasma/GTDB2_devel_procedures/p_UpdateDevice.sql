USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreateDevice]    Script Date: 11/16/2009 13:35:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_UpdateDevice](@id INTEGER,
										@identifier VARCHAR(255),
										@concentration BIT,
										@fragment_length BIT,
										@molar_concentration BIT,
										@show_warning_message bit,
										@warning_message varchar(1024))

AS
BEGIN
SET NOCOUNT ON

-- Create device.
UPDATE device SET identifier = @identifier,
				concentration = @concentration, 
				fragment_length = @fragment_length, 
				molar_concentration = @molar_concentration,
				show_warning_message = @show_warning_message,
				warning_message = @warning_message
WHERE device_id = @id
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update device with identifier: %s', 15, 1, @identifier)
	RETURN
END

SET NOCOUNT OFF
END
