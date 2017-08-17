USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetUserMapping]    Script Date: 11/20/2009 16:09:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_GetUserMapping] (@id INTEGER)

AS
BEGIN
SET NOCOUNT ON

SELECT authority_id AS user_id
FROM authority_mapping
WHERE authority_group_id = @id

SET NOCOUNT OFF
END
