USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetContactCategories]    Script Date: 11/20/2009 15:56:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_GetContactCategories]

AS
BEGIN
SET NOCOUNT ON

SELECT 
	contact_category_id AS id,
	identifier,
	description
FROM contact_category
ORDER BY identifier ASC

SET NOCOUNT OFF
END
