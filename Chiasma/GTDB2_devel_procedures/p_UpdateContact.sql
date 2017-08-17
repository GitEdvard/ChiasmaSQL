USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdateContact]    Script Date: 11/20/2009 16:27:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_UpdateContact](
	@id INTEGER,
	@identifier VARCHAR(255),
	@name VARCHAR(255) = NULL,
	@comment VARCHAR(2048) = NULL)

AS
BEGIN
SET NOCOUNT ON

-- Update contact.
UPDATE contact SET
	identifier = @identifier,
	name = @name,
	comment = @comment
WHERE contact_id = @id
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update contact with id: %s', 15, 1, @id)
	RETURN
END

SET NOCOUNT OFF

END
