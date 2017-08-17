USE [BookKeeping_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetCustomerNumberById]    Script Date: 11/20/2009 16:10:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[p_GetCustomerNumberById](
	@id int
)

AS
BEGIN
SET NOCOUNT ON

SELECT * FROM customer_number_view
where id = @id

SET NOCOUNT OFF
END
