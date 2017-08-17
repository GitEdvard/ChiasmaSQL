USE [BookKeeping_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetUserFromBarcode]    Script Date: 11/20/2009 16:09:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[p_GetUserFromBarcode](
@chiasma_barcode varchar(255)
)

AS
BEGIN
SET NOCOUNT ON

-- Get current user
SELECT *
from authority_view
WHERE chiasma_barcode = @chiasma_barcode

SET NOCOUNT OFF
END
