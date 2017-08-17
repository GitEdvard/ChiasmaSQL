USE [BookKeeping_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetInvoiceCategoryById]    Script Date: 03/25/2010 13:28:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[p_GetInvoiceCategoryById](
@id INTEGER
)

AS
BEGIN
SET NOCOUNT ON

SELECT * FROM invoice_category_view
WHERE id = @id

SET NOCOUNT OFF
END
