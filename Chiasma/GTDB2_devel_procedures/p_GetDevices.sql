USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetDevices]    Script Date: 11/20/2009 15:57:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[p_GetDevices]

AS
BEGIN
SET NOCOUNT ON

SELECT 
	device_id AS id,
	identifier,
	concentration,
	fragment_length,
	molar_concentration,
	show_warning_message,
	warning_message,
	is_mixed
FROM device
ORDER BY identifier ASC

SET NOCOUNT OFF
END
