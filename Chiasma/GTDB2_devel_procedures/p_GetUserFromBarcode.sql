USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetUserFromBarcode]    Script Date: 11/20/2009 16:09:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_GetUserFromBarcode](
@barcode varchar(255)
)

AS
BEGIN
SET NOCOUNT ON

SELECT 
	authority_id AS id,
	identifier,
	name,
	user_type,
	account_status,
	comment,
	barcode.code AS barcode
FROM authority
INNER JOIN barcode ON barcode.identifiable_id = authority.authority_id AND barcode.kind = 'AUTHORITY'
WHERE barcode.code = @barcode


SET NOCOUNT OFF
END
