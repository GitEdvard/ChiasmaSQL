USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreateBeadChipType]    Script Date: 11/16/2009 13:34:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[p_CreateBeadChipType](
	@identifier VARCHAR(255),
	@size_x INTEGER,
	@size_y INTEGER,
	@chiptype VARCHAR(20),
	@default_batch_size INTEGER = NULL,
	@status VARCHAR(30) = 'Active')

AS
BEGIN
SET NOCOUNT ON

-- Create bead chip type.
INSERT INTO bead_chip_type (identifier, size_x, size_y, chiptype, default_batch_size, status)
	VALUES (@identifier, @size_x, @size_y, @chiptype, @default_batch_size, @status)
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to create bead_chip_type with identifier: %s', 15, 1, @identifier)
	RETURN
END

SELECT 
	bead_chip_type_id AS id,
	identifier,
	size_x,
	size_y,
	chiptype,
	default_batch_size,
	status
FROM bead_chip_type
WHERE identifier = @identifier

SET NOCOUNT OFF
END


SET ANSI_NULLS ON
