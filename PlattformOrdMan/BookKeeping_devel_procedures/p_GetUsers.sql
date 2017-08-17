USE [BookKeeping_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetUsers]    Script Date: 11/20/2009 16:10:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[p_GetUsers]

AS
BEGIN
SET NOCOUNT ON

-- Get users
SELECT * 
from authority_view
ORDER BY name ASC

SET NOCOUNT OFF
END
