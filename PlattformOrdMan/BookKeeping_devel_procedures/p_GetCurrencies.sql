USE [BookKeeping_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetPosts]    Script Date: 11/20/2009 16:10:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[p_GetCurrencies]

AS
BEGIN
SET NOCOUNT ON

SELECT * FROM currency_view

SET NOCOUNT OFF
END
