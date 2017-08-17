USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetUserHistory]    Script Date: 11/20/2009 16:09:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_GetUserHistory]( @id INTEGER )

AS
BEGIN
SET NOCOUNT ON

SELECT 
	authority_id AS id,
	identifier,
	name,
	user_type,
	account_status,
	comment,
	changed_date,
	changed_authority_id,
	changed_action
FROM authority_history
WHERE authority_id = @id
ORDER BY changed_date ASC

SET NOCOUNT OFF
END
