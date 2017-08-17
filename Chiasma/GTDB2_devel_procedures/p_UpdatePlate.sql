USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdatePlate]    Script Date: 11/20/2009 16:28:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[p_UpdatePlate](
	@id INTEGER,
	@identifier VARCHAR (255),
	@status VARCHAR (30),
	@status_changed BIT,
	@bead_chip_info_id int = null,
	@method varchar(10),
	@comment VARCHAR(1024) = NULL)

AS
BEGIN
SET NOCOUNT ON

IF @status_changed = 1 AND @status = 'Active'
BEGIN
	EXECUTE p_RestoreGenericContainer @id
END

IF @status_changed = 1 AND @status = 'Disposed'
BEGIN
	EXECUTE p_DisposeGenericContainer @id
END

-- Update plate.
UPDATE plate
SET
	identifier = @identifier,
	status = @status,
	method = @method,
	bead_chip_info_id = @bead_chip_info_id,
	comment = @comment
WHERE plate_id = @id
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update plate with id: %s', 15, 1, @id)
	RETURN
END

SET NOCOUNT OFF
END
