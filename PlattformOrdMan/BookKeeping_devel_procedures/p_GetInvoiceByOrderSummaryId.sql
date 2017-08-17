USE [BookKeeping_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetInvoiceByOrderSummaryId]    Script Date: 11/20/2009 16:10:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_GetInvoiceByOrderSummaryId]
(
	@order_summary_id int
)

AS
BEGIN
SET NOCOUNT ON

SELECT * 
from invoice_view
where order_summary_id = @order_summary_id

SET NOCOUNT OFF
END
