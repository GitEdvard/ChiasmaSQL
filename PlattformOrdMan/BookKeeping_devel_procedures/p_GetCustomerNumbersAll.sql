USE [BookKeeping_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetCustomerNumbersAll]    Script Date: 11/20/2009 16:09:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[p_GetCustomerNumbersAll]

AS
BEGIN
SET NOCOUNT ON

SELECT 
* from customer_number_view

SET NOCOUNT OFF
END 
