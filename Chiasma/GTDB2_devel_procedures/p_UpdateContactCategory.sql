USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdateContactCategory]    Script Date: 11/20/2009 16:27:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_UpdateContactCategory](
	@id INTEGER,
	@identifier VARCHAR(255),
	@description VARCHAR(2048) = NULL)

AS
BEGIN
SET NOCOUNT ON

-- Update contact category.
UPDATE contact_category SET
	identifier = @identifier,
	description = @description
WHERE contact_category_id = @id
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update contact category with id: %s', 15, 1, @id)
	RETURN
END

SET NOCOUNT OFF

END
