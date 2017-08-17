USE [BookKeeping_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetInvoiceCategories]    Script Date: 03/25/2010 13:24:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[p_GetInvoiceCategories]

AS
BEGIN
SET NOCOUNT ON

SELECT 
* FROM invoice_category_view
ORDER BY identifier ASC

SET NOCOUNT OFF
END
