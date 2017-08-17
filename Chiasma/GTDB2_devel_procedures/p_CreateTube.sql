USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreateTube]    Script Date: 11/16/2009 13:40:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_CreateTube](
	@identifier VARCHAR(255),
	@tube_usage VARCHAR(32),
	@barcode_length TINYINT,
	@tube_number INTEGER = NULL,
	@method varchar(10),
	@is_highlighted bit,
	@is_failed bit)

AS
BEGIN
SET NOCOUNT ON

DECLARE @tube_id INTEGER
declare @tube_metadata_id int

-- Create entry in the tube_metadata table
insert into tube_metadata
default values

set @tube_metadata_id = SCOPE_IDENTITY()

-- Get the ID from the generic_container table.
INSERT INTO generic_container (generic_container_type) VALUES ('Tube')

SET @tube_id = SCOPE_IDENTITY()



-- Create tube.
INSERT tube
	(tube_id,
	 identifier,
	 tube_usage,
	 tube_number,
	 method,
	 is_highlighted,
	 is_failed,
	 tube_metadata_id)
VALUES
	(@tube_id,
	 @identifier,
	 @tube_usage,
	 @tube_number,
	 @method,
	 @is_highlighted,
	 @is_failed,
	 @tube_metadata_id)

update tube_metadata set
	tube_id = @tube_id
from tube t inner join tube_metadata tm on t.tube_metadata_id = tm.tube_metadata_id
where t.tube_id = @tube_id


IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to create tube with identifier: %s', 15, 1, @identifier)
	RETURN
END

-- Get tube_id.
SET @tube_id = NULL

SELECT @tube_id = tube_id FROM tube WHERE identifier = @identifier
IF @tube_id IS NULL
BEGIN
	RAISERROR('tube_id for tube was not found', 15, 1)
	RETURN
END

-- Create barcode
EXECUTE p_CreateInternalBarcode @identifiable_id = @tube_id, @kind = 'CONTAINER', @code_length = @barcode_length
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to create barcode for tube with id: %d', 15, 1, @tube_id)
	RETURN
END

SELECT * from tube_view
WHERE id = @tube_id

SET NOCOUNT OFF
END
