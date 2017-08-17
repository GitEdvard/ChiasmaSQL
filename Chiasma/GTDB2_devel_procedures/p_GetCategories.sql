USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetStates]    Script Date: 11/20/2009 16:08:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_GetCategories]
(@category_type varchar(50))

AS
BEGIN
SET NOCOUNT ON

SELECT
	category_id AS id,
	identifier,
	comment,
	enabled,
	tag, 
	category_type
FROM category WHERE category_type LIKE @category_type
ORDER BY identifier ASC

SET NOCOUNT OFF
END
