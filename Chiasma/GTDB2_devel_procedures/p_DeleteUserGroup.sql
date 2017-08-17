USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_DeleteUserGroup]    Script Date: 11/20/2009 15:46:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_DeleteUserGroup] (@id INTEGER)

AS
BEGIN
SET NOCOUNT ON

-- Delete user group.
DELETE FROM authority_group
WHERE authority_group_id = @id

SET NOCOUNT OFF
END
