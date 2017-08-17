USE [BookKeeping_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetMerchandise]    Script Date: 11/20/2009 16:10:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[p_GetMerchandise]

AS
BEGIN
SET NOCOUNT ON

select * from merchandise_view 
ORDER BY ISNULL(supplier_identifier, '000') ASC, identifier ASC

SET NOCOUNT OFF
END
