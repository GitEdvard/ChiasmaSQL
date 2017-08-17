USE [BookKeeping_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetOrderSummariesByCustomerNumberId]    Script Date: 11/20/2009 16:10:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[p_GetOrderSummariesByCustomerNumberId]
(
	@customer_number_id int
)

AS
BEGIN
SET NOCOUNT ON

SELECT * 
from order_summary_view
where customer_number_id = @customer_number_id

SET NOCOUNT OFF
END
