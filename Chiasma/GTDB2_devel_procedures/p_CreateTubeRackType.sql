USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreateTubeRackType]    Script Date: 11/16/2009 13:40:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_CreateTubeRackType](
	@identifier VARCHAR(255),
	@size_x INTEGER,
	@size_y INTEGER,
	@description VARCHAR(512) = NULL)

AS
BEGIN
SET NOCOUNT ON

-- Create tube rack type.
INSERT INTO tube_rack_type (identifier, size_x, size_y, description)
	VALUES (@identifier, @size_x, @size_y, @description)
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to create tube_rack_type with identifier: %s', 15, 1, @identifier)
	RETURN
END

SELECT 
	tube_rack_type_id AS id,
	identifier,
	size_x,
	size_y,
	description
FROM tube_rack_type WHERE identifier = @identifier
SET NOCOUNT OFF

END
