USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdateUser]    Script Date: 11/20/2009 16:31:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_UpdateUser](
	@id INTEGER,
	@identifier VARCHAR(255),
	@name VARCHAR(255),
	@user_type VARCHAR(32),
	@account_status BIT,
	@comment VARCHAR(1024) = NULL)

AS
BEGIN
SET NOCOUNT ON

-- Update user.
UPDATE authority SET
	identifier = @identifier,
	name = @name,
	user_type = @user_type,
	account_status = @account_status,
	comment = @comment
WHERE authority_id = @id
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update user with id: %s', 15, 1, @id)
	RETURN
END

SET NOCOUNT OFF
END
