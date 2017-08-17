USE [BookKeeping_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_DeleteCustomerNumber]    Script Date: 11/20/2009 16:09:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[p_DeleteCustomerNumber](
@id INTEGER
)

AS
BEGIN
SET NOCOUNT ON

DELETE FROM customer_number WHERE customer_number_id = @id

SET NOCOUNT OFF
END 
