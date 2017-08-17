USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetUserCurrent]    Script Date: 11/20/2009 16:09:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[p_GetUserCurrent]

AS
BEGIN
SET NOCOUNT ON

-- Get current user
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
WHERE authority_id = dbo.fGetAuthorityId()

SET NOCOUNT OFF
END
