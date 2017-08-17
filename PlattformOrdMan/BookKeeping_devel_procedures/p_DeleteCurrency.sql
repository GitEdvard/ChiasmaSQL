USE [BookKeeping_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_DeleteUser]    Script Date: 11/20/2009 16:09:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[p_DeleteCurrency](
@currency_id INTEGER
)

AS
BEGIN
SET NOCOUNT ON

DELETE FROM currency WHERE currency_id = @currency_id

SET NOCOUNT OFF
END 
