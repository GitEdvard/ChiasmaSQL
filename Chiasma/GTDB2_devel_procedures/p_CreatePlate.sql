USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreatePlate]    Script Date: 11/16/2009 13:37:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_CreatePlate](
	@identifier VARCHAR(255),
	@plate_type_id INTEGER,
	@plate_usage VARCHAR(32),
	@barcode_length TINYINT,
	@comment VARCHAR(1024) = NULL,
	@external_barcode VARCHAR(32) = NULL,
	@plate_number int = null,
	@sample_series_id int = null,
	@method varchar(10))

AS
BEGIN
SET NOCOUNT ON

DECLARE @plate_id INTEGER

-- Get the ID from the generic_container table.
INSERT INTO generic_container (generic_container_type) VALUES ('Plate')

SET @plate_id = SCOPE_IDENTITY()

-- Create plate.
INSERT INTO plate
	(plate_id,
	 identifier,
	 plate_type_id,
	 plate_usage,
	 comment,
	 plate_number,
	 sample_series_id,
	 method)
VALUES
	(@plate_id,
	 @identifier,
	 @plate_type_id,
	 @plate_usage,
	 @comment, 
	 @plate_number,
	 @sample_series_id,
	 @method)
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to create plate with identifier: %s', 15, 1, @identifier)
	RETURN
END

-- Get plate_id.
SET @plate_id = NULL

SELECT @plate_id = plate_id FROM plate WHERE identifier = @identifier
IF @plate_id IS NULL
BEGIN
	RAISERROR('plate_id for plate was not found', 15, 1)
	RETURN
END

IF @external_barcode IS NULL
BEGIN
	EXECUTE p_CreateInternalBarcode @identifiable_id = @plate_id, @kind = 'CONTAINER', @code_length = @barcode_length
END
ELSE
BEGIN
	EXECUTE p_CreateExternalBarcode @barcode = @external_barcode,  @identifiable_id = @plate_id, @kind = 'CONTAINER'
END

SELECT * FROM plate_view
WHERE id = @plate_id

SET NOCOUNT OFF
END
