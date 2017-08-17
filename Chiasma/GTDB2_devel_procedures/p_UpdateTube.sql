USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdateTube]    Script Date: 11/20/2009 16:30:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[p_UpdateTube](
	@id INTEGER,
	@identifier VARCHAR (255),
	@status VARCHAR (30),
	@status_changed BIT,
	@method varchar(10),
	@comment VARCHAR(1024) = NULL,
	@is_highlighted bit,
	@is_failed bit
)

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

-- Update tube.
UPDATE tube
SET
	identifier = @identifier,
	status = @status,
	comment = @comment,
	method = @method,
	is_highlighted = @is_highlighted,
	is_failed = @is_failed
WHERE tube_id = @id
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update tube with id: %d', 15, 1, @id)
	RETURN
END

SET NOCOUNT OFF
END
