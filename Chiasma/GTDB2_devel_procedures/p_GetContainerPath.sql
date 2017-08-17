USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetContainerPath]    Script Date: 11/20/2009 15:57:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_GetContainerPath] (@id AS INTEGER) 
-- THIS PROCEDURE WILL SELECT ROWS WITH CONTAINER IDENTIFIERS AND
-- IDS WHICH REPRESENT THE PATH TO THE IDENTIFIABLE ITEM GIVEN AS ARGUMENT. 
-- THE FIRST ROW IS THE TOP-MOST CONTAINER AND SO ON UNTIL THE LAST ROW WHICH
-- IS THE CONTAINER DIRECTLY CONTAINING THE IDENTIFIABLE. IF THE
-- IDENTIFIABLE IS NOT WITHIN ANY CONTAINER, AN EMPTY ROWSET WILL
-- BE SELECTED.
 
AS
BEGIN
SET NOCOUNT ON

DECLARE @tempParentContainerID INTEGER
DECLARE @tempParentIdentifier VARCHAR(255)
DECLARE @tempChildID INTEGER
DECLARE @counter INTEGER
DECLARE @maxCount INTEGER

DECLARE @result TABLE(container_id INTEGER,
			   identifier VARCHAR(255),
			   type VARCHAR(255),
			   status VARCHAR(32),
			   barcode VARCHAR(255),
			   comment VARCHAR(1024),
			   level_count INTEGER)

SET @tempChildID = @id
SET @counter = 1

SET @tempParentContainerID = 1  --GET THE WHILE LOOP GOING IN THE FIRST ROUND.

WHILE @tempParentContainerID > 0
BEGIN
	SET @tempParentContainerID = 0
	SELECT @tempParentContainerID = parent_container_id FROM contents 
	WHERE child_container_id = @tempChildID

	IF NOT @tempParentContainerID IS NULL
	BEGIN
		IF @tempParentContainerID > 0
		BEGIN
			--GET THE IDENTIFIER.
			SELECT @tempParentIdentifier = identifier 
			FROM container WHERE container_id = @tempParentContainerID 
			
			--RAISE ERROR IF THE IDENTIFIER COULD NOT BE FOUND.
			IF @tempParentIdentifier IS NULL
			BEGIN
				RAISERROR('Unable to find identifier for container with ID number: %i', 
							15, 1, @tempParentContainerID)
				RETURN				
			END
			
			--STORE THE RESULT.
			INSERT INTO @result (container_id, identifier, type, status, barcode, comment, level_count) 
			SELECT 
				c.container_id AS id,
				c.identifier,
				ct.name AS type,
				c.status,
				b.code AS barcode,
				c.comment AS comment,
				@counter
			FROM container AS c
			INNER JOIN container_type AS ct ON ct.container_type_id = c.container_type_id
			LEFT OUTER JOIN barcode AS b ON b.identifiable_id = c.container_id AND b.kind = 'CONTAINER'
			WHERE c.container_id = @tempParentContainerID

			--RECURSIVELY SEARCH FOR THE NEXT CONTAINER.			
			SET @tempChildID = @tempParentContainerID
		END
	END
	
	SET @counter = @counter + 1
	IF @counter > 100 BREAK
END

SELECT @maxCount = MAX(level_count) FROM @result

SELECT container_id AS id, identifier, type, status, barcode, comment, @maxCount-level_count AS tree_level FROM @result
ORDER BY tree_level ASC

SET NOCOUNT OFF
END
