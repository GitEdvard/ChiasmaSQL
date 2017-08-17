USE [BookKeeping_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetArticleNumberByMerchandiseId]    Script Date: 11/20/2009 16:10:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_GetArticleNumberByMerchandiseId]
(
	@merchandise_id int
)

AS
BEGIN
SET NOCOUNT ON

SELECT 
	article_number_id as id,
	identifier,
	merchandise_id,
	active
FROM article_number WHERE merchandise_id = @merchandise_id

SET NOCOUNT OFF
END
