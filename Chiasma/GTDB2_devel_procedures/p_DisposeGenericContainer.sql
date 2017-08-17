USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_DisposeGenericContainer]    Script Date: 11/20/2009 15:46:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_DisposeGenericContainer](@id AS INTEGER) 
-- ALL ENTRIES IN TABLE CONTENTS FOR DISPOSED CONTAINERS ARE REMOVED.
 
AS
BEGIN
SET NOCOUNT ON

-- Delete possible entry in contents table for disposed container.
DELETE FROM contents WHERE child_container_id = @id
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to dispose container with id: %d', 15, 1, @id)
	RETURN
END

SET NOCOUNT OFF
END
