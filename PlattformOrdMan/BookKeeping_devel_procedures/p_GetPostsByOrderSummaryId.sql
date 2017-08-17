USE [BookKeeping_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetPostsByOrderSummaryId]    Script Date: 11/20/2009 16:10:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[p_GetPostsByOrderSummaryId]
(
	@order_summary_id int
)

AS
BEGIN
SET NOCOUNT ON

SELECT * 
from post_history_table_version_2
where order_summary_id = @order_summary_id

SET NOCOUNT OFF
END
