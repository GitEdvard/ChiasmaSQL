USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetContacts]    Script Date: 11/20/2009 15:56:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_GetContacts]

AS
BEGIN
SET NOCOUNT ON

SELECT 
	contact_id AS id,
	identifier,
	name,
	comment
FROM contact
ORDER BY identifier ASC

SET NOCOUNT OFF
END
