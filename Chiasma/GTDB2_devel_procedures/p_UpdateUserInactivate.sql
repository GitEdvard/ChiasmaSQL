USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdateUserInactivate]    Script Date: 11/20/2009 16:31:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_UpdateUserInactivate] (@id INTEGER)

AS
BEGIN
SET NOCOUNT ON

-- Remove mappings for this user
DELETE FROM authority_mapping	
WHERE authority_id = @id
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to delete mappings for user with id: %d', 15, 1, @id)
	RETURN
END

-- Update user.
UPDATE authority SET
	account_status = 0
WHERE authority_id = @id
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update user with id: %d', 15, 1, @id)
	RETURN
END

SET NOCOUNT OFF
END
