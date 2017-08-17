USE [BookKeeping_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetPlaceOfPurchases]    Script Date: 11/20/2009 16:10:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_GetPlaceOfPurchases]

AS
BEGIN
SET NOCOUNT ON

SELECT place_of_purchase_id, code
from place_of_purchase

SET NOCOUNT OFF
END
