USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdateUserGroup]    Script Date: 11/20/2009 16:31:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_UpdateUserGroup](
	@id INTEGER,
	@identifier VARCHAR(255),
	@comment VARCHAR(1024) = NULL)

AS
BEGIN
SET NOCOUNT ON

-- Update user group.
UPDATE authority_group SET
	identifier = @identifier,
	comment = @comment
WHERE authority_group_id = @id
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update user group with id: %s', 15, 1, @id)
	RETURN
END

SET NOCOUNT OFF
END
