
USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreateDevice]    Script Date: 11/16/2009 13:35:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_CreateDevice](@identifier VARCHAR(255),
										@concentration BIT,
										@fragment_length BIT,
										@molar_concentration BIT,
										@show_warning_message bit,
										@warning_message varchar(1024))

AS
BEGIN
SET NOCOUNT ON

-- Create device.
INSERT INTO device 
(identifier, concentration, fragment_length, molar_concentration, show_warning_message, warning_message) 
VALUES 
(@identifier, @concentration, @fragment_length, @molar_concentration, @show_warning_message, @warning_message)
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to create device with identifier: %s', 15, 1, @identifier)
	RETURN
END

SELECT 
	device_id AS id,
	identifier,
	concentration,
	fragment_length,
	molar_concentration,
	show_warning_message,
	warning_message,
	is_mixed
FROM device WHERE identifier = @identifier

SET NOCOUNT OFF
END
