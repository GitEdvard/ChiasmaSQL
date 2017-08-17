USE [BookKeeping_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetSupplierById]    Script Date: 11/20/2009 16:10:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[p_GetSupplierById](
@id INTEGER
)

AS
BEGIN
SET NOCOUNT ON

SELECT * FROM supplier_view
WHERE id = @id

SET NOCOUNT OFF
END
