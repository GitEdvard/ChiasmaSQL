USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreateUserGroup]    Script Date: 11/16/2009 13:40:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_CreateUserGroup]
	(@identifier VARCHAR(255),
	 @identifiable_id INTEGER = NULL,
	 @user_group_type VARCHAR(32))

AS
BEGIN
SET NOCOUNT ON

-- Create user group.
INSERT INTO authority_group (identifier, comment, identifiable_id, authority_group_type)
	VALUES (@identifier, NULL, @identifiable_id, @user_group_type)
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to create user group with identifier: %s', 15, 1, @identifier)
	RETURN
END

SELECT 
	authority_group_id AS id,
	identifier,
	comment,
	identifiable_id,
	authority_group_type AS user_group_type
FROM authority_group WHERE identifier = @identifier
SET NOCOUNT OFF

END
