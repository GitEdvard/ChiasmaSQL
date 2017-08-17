USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_RestoreGenericContainer]    Script Date: 11/20/2009 16:26:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_RestoreGenericContainer](@id AS INTEGER) 
-- This procedure will restore a disposed container.
-- All entries in table contents for restored containers are inserted again.
 
AS
BEGIN
SET NOCOUNT ON

DECLARE @parent_container_id INTEGER
DECLARE @parent_container_status VARCHAR(32)

-- Get last container that this generic container was placed in.
SELECT TOP 1
	@parent_container_id = generic_container_id,
	@parent_container_status = status
FROM all_containers
WHERE generic_container_id IN
	(SELECT TOP 1 to_container_id FROM container_move
	 WHERE moved_container_id = @id
	 ORDER BY moved DESC)
IF @parent_container_id IS NOT NULL
BEGIN
	IF @parent_container_status = 'Active'
	BEGIN
		-- Restore entry in contents table.
		INSERT INTO contents
			(parent_container_id,
			 child_container_id) 
		VALUES
			(@parent_container_id,
			 @id)
		IF @@ERROR <> 0
		BEGIN
			RAISERROR('Failed to restore container with id: %d', 15, 1, @id)
			RETURN
		END
	END
	ELSE
	BEGIN
		-- Move container to uncontained list.
		EXECUTE p_MoveContainer @id
	END
END

SET NOCOUNT OFF
END
