USE [BookKeeping_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_DeleteOrderSummary]    Script Date: 03/25/2010 15:48:40 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_DeleteOrderSummary](
@id INTEGER
)
  
AS
BEGIN
SET NOCOUNT ON

delete from post_table_version_2 where order_summary_id = @id

DELETE FROM order_summary WHERE order_summary_id = @id

SET NOCOUNT OFF
END
