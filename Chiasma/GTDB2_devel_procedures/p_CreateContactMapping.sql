USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreateContactMapping]    Script Date: 11/16/2009 13:35:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_CreateContactMapping](
	@id INTEGER,
	@contact_id INTEGER)

AS
BEGIN
SET NOCOUNT ON

-- Create contact mapping.
INSERT INTO contact_mapping (contact_category_id, contact_id)
VALUES (@id, @contact_id)
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to create contact mapping with contact category id: %s', 15, 1, @id)
	RETURN
END

SET NOCOUNT OFF
END
