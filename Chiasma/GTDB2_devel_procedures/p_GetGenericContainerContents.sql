USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetGenericContainerContents]    Script Date: 11/20/2009 15:59:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Get containers inside this container.
ALTER PROCEDURE [dbo].[p_GetGenericContainerContents] (
	@id INTEGER,
	@identifier_filter VARCHAR(255))

AS
BEGIN

DECLARE @select_command VARCHAR (1024)

SET @select_command = 'SELECT generic_container_id FROM all_containers
				WHERE generic_container_id IN (SELECT child_container_id FROM contents
								WHERE parent_container_id = ' + STR(@id) + ')
				AND identifier LIKE ''' + @identifier_filter + ''''

EXECUTE p_GetGenericContainers @select_command

END
