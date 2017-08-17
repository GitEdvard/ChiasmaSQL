USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetContactMapping]    Script Date: 11/20/2009 15:56:47 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_GetContactMapping] (@id INTEGER)

AS
BEGIN
SET NOCOUNT ON

SELECT contact_id
FROM contact_mapping
WHERE contact_category_id = @id

SET NOCOUNT OFF
END
