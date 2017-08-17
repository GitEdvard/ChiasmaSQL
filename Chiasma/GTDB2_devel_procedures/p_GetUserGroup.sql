USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetUserGroup]    Script Date: 11/20/2009 16:09:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_GetUserGroup]
	(@identifier VARCHAR(255),
	 @identifiable_id INTEGER = NULL,
	 @user_group_type VARCHAR(32))

AS
BEGIN
SET NOCOUNT ON

SELECT 
	authority_group_id AS id,
	identifier,
	comment,
	identifiable_id,
	authority_group_type AS user_group_type
FROM authority_group
WHERE 
	identifier = @identifier AND
	identifiable_id = @identifiable_id AND
	authority_group_type = @user_group_type

SET NOCOUNT OFF
END
