USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetUsers]    Script Date: 11/20/2009 16:10:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_GetUsers]

AS
BEGIN
SET NOCOUNT ON

-- Get users
SELECT 
	authority_id AS id,
	identifier,
	name,
	user_type,
	account_status,
	comment,
	barcode.code AS barcode
FROM authority
LEFT JOIN barcode ON barcode.identifiable_id = authority.authority_id AND barcode.kind = 'AUTHORITY'
ORDER BY name ASC

SET NOCOUNT OFF
END
