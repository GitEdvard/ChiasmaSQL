USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreateContainer]    Script Date: 11/16/2009 13:35:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_CreateContainer](
	@identifier VARCHAR(255),
	@type VARCHAR(32),
	@barcode_length TINYINT,
	@size_x INTEGER = NULL,
	@size_y INTEGER = NULL,
	@size_z INTEGER = NULL,
	@external_barcode VARCHAR(255) = NULL)

AS
BEGIN
SET NOCOUNT ON

DECLARE @container_id INTEGER

-- Get the ID from the generic_container table.
INSERT INTO generic_container (generic_container_type) VALUES ('Container')

SET @container_id = SCOPE_IDENTITY()

-- Create container.
INSERT INTO container
	(container_id,
	 identifier,
	 container_type_id,
	 size_x,
	 size_y,
	 size_z)
SELECT
	@container_id,
	@identifier, 
	container_type_id,
	@size_x,
	@size_y,
	@size_z
FROM container_type
WHERE name = @type
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to create container with identifier: %s', 15, 1, @identifier)
	RETURN
END

-- Get container_id.
SET @container_id = NULL

SELECT @container_id = container_id FROM container WHERE identifier = @identifier
IF @container_id IS NULL
BEGIN
	RAISERROR('container_id for container was not found', 15, 1)
	RETURN
END

-- Create bar code.
IF @external_barcode IS NULL
BEGIN
	EXECUTE p_CreateInternalBarcode @identifiable_id = @container_id, @kind = 'CONTAINER', @code_length = @barcode_length
END
ELSE
BEGIN
	EXECUTE p_CreateExternalBarcode @barcode = @external_barcode,  @identifiable_id = @container_id, @kind = 'CONTAINER'
END

-- Return container.
SELECT 
	container.container_id AS id,
	container.identifier,
	container_type.name AS type,
	container.status,
	barcode.code AS barcode,
	container.comment AS comment
FROM container
INNER JOIN container_type
ON container_type.container_type_id = container.container_type_id
LEFT OUTER JOIN barcode
ON barcode.identifiable_id = container.container_id AND barcode.kind = 'CONTAINER'
WHERE container.container_id = @container_id

SET NOCOUNT OFF
END
