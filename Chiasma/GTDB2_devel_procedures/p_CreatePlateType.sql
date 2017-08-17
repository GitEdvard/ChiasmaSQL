USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreatePlateType]    Script Date: 11/16/2009 13:38:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_CreatePlateType](
	@identifier VARCHAR(255),
	@size_x INTEGER,
	@size_y INTEGER,
	@description VARCHAR(512) = NULL)

AS
BEGIN
SET NOCOUNT ON

-- Create plate type.
INSERT INTO plate_type (identifier, size_x, size_y, description)
	VALUES (@identifier, @size_x, @size_y, @description)
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to create plate_type with identifier: %s', 15, 1, @identifier)
	RETURN
END

SELECT 
	plate_type_id AS id,
	identifier,
	size_x,
	size_y,
	description
FROM plate_type WHERE identifier = @identifier
SET NOCOUNT OFF

END
