USE [BookKeeping_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_DeleteSupplier]    Script Date: 11/20/2009 16:10:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[p_DeleteSupplier](
@id INTEGER
)

AS
BEGIN
SET NOCOUNT ON

delete from customer_number where supplier_id = @id

DELETE FROM supplier WHERE supplier_id = @id

SET NOCOUNT OFF
END
