USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_DeleteDevice]    Script Date: 11/16/2009 13:35:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_DeleteDevice](@id INTEGER)

AS
BEGIN
SET NOCOUNT ON

-- Delete device.
DELETE FROM device WHERE device_id = @id

IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to delete device with id: %s', 15, 1, @id)
	RETURN
END

SET NOCOUNT OFF
END
