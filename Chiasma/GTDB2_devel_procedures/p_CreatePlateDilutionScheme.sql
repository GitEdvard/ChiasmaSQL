USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreatePlateDilutionScheme]    Script Date: 11/16/2009 13:37:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_CreatePlateDilutionScheme](
	@identifier VARCHAR(255),
	@plate_type_id INTEGER,
	@comment VARCHAR(512) = NULL)

AS
BEGIN
SET NOCOUNT ON

-- Create plate dilution scheme.
INSERT INTO plate_dilution_scheme (identifier, plate_type_id, comment)
	VALUES (@identifier, @plate_type_id, @comment)
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to create plate_dilution_scheme with identifier: %s', 15, 1, @identifier)
	RETURN
END

-- Return created object.
SELECT 
	plate_dilution_scheme_id AS id,
	identifier,
	plate_type_id,
	comment
FROM plate_dilution_scheme
WHERE identifier = @identifier AND
	plate_type_id = @plate_type_id

SET NOCOUNT OFF
END
