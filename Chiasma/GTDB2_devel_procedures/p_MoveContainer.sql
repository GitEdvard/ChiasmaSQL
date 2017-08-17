USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_MoveContainer]    Script Date: 11/20/2009 16:25:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_MoveContainer](
	@id INTEGER,
	@to_container_id INTEGER = NULL,
	@to_position_x INTEGER = NULL,
	@to_position_y INTEGER = NULL,
	@to_position_z INTEGER = NULL,
	@authority_id INTEGER = NULL)

AS
BEGIN
SET NOCOUNT ON

-- Get from_container_id.
DECLARE @from_container_id INTEGER
DECLARE @from_position_x INTEGER
DECLARE @from_position_y INTEGER
DECLARE @from_position_z INTEGER
SELECT
	@from_container_id = parent_container_id,
	@from_position_x = position_x,
	@from_position_z = position_y,
	@from_position_z = position_z
FROM contents WHERE child_container_id = @id
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to move container with id: %d', 15, 1, @id)
	RETURN
END

-- Update container_move tabel with information about this move.
IF ISNULL(@authority_id, 0) = 0
BEGIN
	INSERT INTO container_move
		(moved_container_id,
		 from_container_id,
		 from_position_x,
		 from_position_y,
		 from_position_z,
		 to_container_id,
		 to_position_x,
		 to_position_y, 
		 to_position_z) 
	VALUES
		(@id,
		 @from_container_id,
		 @from_position_x,
		 @from_position_y,
		 @from_position_z,
		 @to_container_id,
		 @to_position_x,
		 @to_position_y,
		 @to_position_z)
END
ELSE
BEGIN
	INSERT INTO container_move
		(moved_container_id,
		 from_container_id,
		 from_position_x,
		 from_position_y,
		 from_position_z,
		 to_container_id,
		 to_position_x,
		 to_position_y, 
		 to_position_z,
		 authority_id) 
	VALUES
		(@id,
		 @from_container_id,
		 @from_position_x,
		 @from_position_y,
		 @from_position_z,
		 @to_container_id,
		 @to_position_x,
		 @to_position_y,
		 @to_position_z,
		 @authority_id)
END
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to move container with id: %d', 15, 1, @id)
	RETURN
END

-- Delete possible row from contents.
DELETE FROM contents where child_container_id = @id

-- Add child container to parent container.
IF @to_container_id IS NOT NULL
BEGIN
	INSERT INTO contents
		(parent_container_id,
		 child_container_id,
		 position_x,
		 position_y,
		 position_z) 
	VALUES
		(@to_container_id,
		 @id,
		 @to_position_x,
		 @to_position_y,
		 @to_position_z)
	IF @@ERROR <> 0
	BEGIN
		RAISERROR('Failed to move container with id: %d', 15, 1, @id)
		RETURN
	END
END

SET NOCOUNT OFF
END
