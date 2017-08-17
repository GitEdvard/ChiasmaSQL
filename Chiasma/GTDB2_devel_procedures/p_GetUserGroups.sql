USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetUserGroups]    Script Date: 11/20/2009 16:09:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_GetUserGroups]

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
WHERE identifiable_id IS NULL
ORDER BY identifier ASC

SET NOCOUNT OFF
END
