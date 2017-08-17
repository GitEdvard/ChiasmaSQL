USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreateTubeRack]    Script Date: 11/16/2009 13:37:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_CreateTubeRack](
	@identifier VARCHAR(255),
	@tube_rack_type_id INTEGER,
	@empty_slots int,
	@tube_rack_number int,
	@comment varchar(1024),
	@barcode_length TINYINT
)
AS
BEGIN
SET NOCOUNT ON

DECLARE @tube_rack_id INTEGER

-- Get the ID from the generic_container table.
INSERT INTO generic_container (generic_container_type) VALUES ('TubeRack')

SET @tube_rack_id = SCOPE_IDENTITY()

-- Create plate.
INSERT INTO tube_rack
	(tube_rack_id,
	 identifier,
	 tube_rack_type_id,
	 empty_slots,
	 tube_rack_number,
	 comment
)
VALUES
	(@tube_rack_id,
	 @identifier,
	 @tube_rack_type_id,
	 @empty_slots,
	 @tube_rack_number,
	 @comment
)
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to create tube rack with identifier: %s', 15, 1, @identifier)
	RETURN
END

-- Get plate_id.
SET @tube_rack_id = NULL

SELECT @tube_rack_id = tube_rack_id FROM tube_rack WHERE identifier = @identifier
IF @tube_rack_id IS NULL
BEGIN
	RAISERROR('tube_rack_id for tube rack was not found', 15, 1)
	RETURN
END

EXECUTE p_CreateInternalBarcode @identifiable_id = @tube_rack_id, @kind = 'CONTAINER', @code_length = @barcode_length

SELECT * FROM tube_rack_view
WHERE id = @tube_rack_id

SET NOCOUNT OFF
END
