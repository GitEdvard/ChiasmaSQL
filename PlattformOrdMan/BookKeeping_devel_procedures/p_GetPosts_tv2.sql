USE [BookKeeping_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetPosts_tv2]    Script Date: 11/20/2009 16:10:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[p_GetPosts_tv2](
@booker_from_date DATETIME = NULL,
@time_restriction_to_completed_posts BIT
)

AS
BEGIN
SET NOCOUNT ON

select * from post_table_version_2_view
WHERE book_date > ISNULL(@booker_from_date, 0) OR 
(@time_restriction_to_completed_posts = 1 AND invoice_status = 'Incoming')

SET NOCOUNT OFF
END
