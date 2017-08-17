USE [BookKeeping_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetOrderSummaries]    Script Date: 11/20/2009 16:10:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[p_GetOrderSummaries]
(
	@from_order_date DATETIME = NULL,
	@time_restriction_to_completed BIT
)

AS
BEGIN
SET NOCOUNT ON

SELECT * 
from order_summary_view
where order_date > isnull(@from_order_date, 0) or
(@time_restriction_to_completed = 1 and invoice_status = 'Incoming')

SET NOCOUNT OFF
END
