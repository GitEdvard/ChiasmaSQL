USE [BookKeeping_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetUserCurrent]    Script Date: 11/20/2009 16:09:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[p_GetUserCurrent]

AS
BEGIN
SET NOCOUNT ON

-- Get current user
SELECT * 
from authority_view
WHERE id = dbo.fGetAuthorityId()

SET NOCOUNT OFF
END
