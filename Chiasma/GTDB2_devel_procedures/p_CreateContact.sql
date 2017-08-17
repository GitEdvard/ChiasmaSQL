USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreateContact]    Script Date: 11/16/2009 13:35:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[p_CreateContact](
	@identifier VARCHAR(255),
	@name VARCHAR(255) = NULL,
	@comment VARCHAR(2048) = NULL)
--Test1

--Test2

AS
BEGIN
SET NOCOUNT ON

-- Create contact.
INSERT INTO contact (identifier, name, comment)
VALUES (@identifier, @name, @comment)
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to create contact with identifier: %s', 15, 1, @identifier)
	RETURN
END

SELECT 
	contact_id AS id,
	identifier,
	name,
	comment
FROM contact WHERE identifier = @identifier
SET NOCOUNT OFF

END
