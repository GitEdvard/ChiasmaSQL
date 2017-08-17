USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreateContactCategory]    Script Date: 11/16/2009 13:35:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_CreateContactCategory](
	@identifier VARCHAR(255),
	@description VARCHAR(2048) = NULL)

AS
--TEst1

BEGIN
SET NOCOUNT ON

-- Create contact category.
INSERT INTO contact_category (identifier, description)
VALUES (@identifier, @description)
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to create contact category with identifier: %s', 15, 1, @identifier)
	RETURN
END

SELECT 
	contact_category_id AS id,
	identifier,
	description
FROM contact_category WHERE identifier = @identifier
SET NOCOUNT OFF

END
