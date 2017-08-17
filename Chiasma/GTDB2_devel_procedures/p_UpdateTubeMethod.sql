USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdateTubeMethod]    Script Date: 11/20/2009 16:30:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_UpdateTubeMethod](
	@id INTEGER,
	@method varchar(10)
)

AS
BEGIN
SET NOCOUNT ON

-- Update tube.
UPDATE tube
SET
	method = @method
WHERE tube_id = @id
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update tube with id: %d', 15, 1, @id)
	RETURN
END

SET NOCOUNT OFF
END
