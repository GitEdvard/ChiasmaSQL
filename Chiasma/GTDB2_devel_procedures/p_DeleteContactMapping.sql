USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_DeleteContactMapping]    Script Date: 11/20/2009 15:42:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_DeleteContactMapping](
	@id INTEGER,
	@contact_id INTEGER)

AS
BEGIN
SET NOCOUNT ON

-- Delete contact mapping.
DELETE FROM contact_mapping
WHERE
	contact_category_id = @id AND
	contact_id = @contact_id

SET NOCOUNT OFF
END
