USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreateUser]    Script Date: 11/16/2009 13:40:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_CreateUser](
	@identifier VARCHAR(255),
	@name VARCHAR(255),
	@user_type VARCHAR(32),
	@account_status BIT,
	@comment VARCHAR(1024) = NULL,
	@barcode_length TINYINT)

AS
BEGIN
SET NOCOUNT ON

DECLARE @user_id INTEGER

-- Create user.
INSERT INTO authority (identifier, name, user_type, account_status, comment)
VALUES (@identifier, @name, @user_type, @account_status, @comment)

IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to create user with identifier: %s', 15, 1, @identifier)
	RETURN
END

SET @user_id = SCOPE_IDENTITY()

EXECUTE p_CreateInternalBarcode @identifiable_id = @user_id, @kind = 'AUTHORITY', @code_length = @barcode_length

SELECT 
	authority_id AS id,
	identifier,
	name,
	user_type,
	account_status,
	comment,
	barcode.code AS barcode
FROM authority
LEFT OUTER JOIN barcode ON barcode.identifiable_id = authority.authority_id AND barcode.kind = 'AUTHORITY'
WHERE identifier = @identifier


SET NOCOUNT OFF
END
