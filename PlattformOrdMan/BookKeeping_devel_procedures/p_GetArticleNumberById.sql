USE [BookKeeping_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetArticleNumberById]    Script Date: 11/20/2009 16:10:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_GetArticleNumberById]
(
	@article_number_id int
)

AS
BEGIN
SET NOCOUNT ON

select * from article_number_view 
WHERE id = @article_number_id

SET NOCOUNT OFF
END
