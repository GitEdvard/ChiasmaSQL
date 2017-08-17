USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetItem]    Script Date: 11/20/2009 16:01:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- Get item that is associated with a bar code.
-- The values identifiable_id and type in the result set may be null
-- if a bar code has been defined but not associated with an item.
CREATE PROCEDURE [dbo].[p_GetItem] (@barcode VARCHAR(255))

AS
BEGIN
SET NOCOUNT ON

-- Get item
SELECT 
	barcode.code AS barcode,
	barcode.identifiable_id AS identifiable_id,
	kind.name AS kind
FROM barcode
LEFT OUTER JOIN kind
ON kind.kind_id = barcode.kind_id
WHERE barcode.code = @barcode

SET NOCOUNT OFF
END
