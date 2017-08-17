USE [BookKeeping_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetSuppliers]    Script Date: 11/20/2009 16:10:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[p_GetSuppliers]

AS
BEGIN
SET NOCOUNT ON

SELECT * from supplier_view
ORDER BY identifier ASC

SET NOCOUNT OFF
END
