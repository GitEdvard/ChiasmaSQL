USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreateUserMapping]    Script Date: 11/16/2009 13:40:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_CreateUserMapping](
	@id INTEGER,
	@user_id INTEGER)

AS
BEGIN
SET NOCOUNT ON

-- Create user mapping.
INSERT INTO authority_mapping (authority_group_id, authority_id)
VALUES (@id, @user_id)
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to create user mapping with user group id: %d', 15, 1, @id)
	RETURN
END

SET NOCOUNT OFF
END
