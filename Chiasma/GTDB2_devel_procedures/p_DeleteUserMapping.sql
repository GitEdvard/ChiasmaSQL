USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_DeleteUserMapping]    Script Date: 11/20/2009 15:46:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_DeleteUserMapping](
	@id INTEGER,
	@user_id INTEGER)

AS
BEGIN
SET NOCOUNT ON

-- Delete user mapping.
DELETE FROM authority_mapping
WHERE
	authority_group_id = @id AND
	authority_id = @user_id

SET NOCOUNT OFF
END
