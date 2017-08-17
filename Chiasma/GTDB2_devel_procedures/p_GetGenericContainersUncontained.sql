USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetGenericContainersUncontained]    Script Date: 11/20/2009 15:59:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_GetGenericContainersUncontained] (@identifier_filter VARCHAR(255))

AS
BEGIN

DECLARE @select_command VARCHAR (1024)

SET @select_command = 'SELECT all_containers.generic_container_id FROM all_containers
	INNER JOIN container_type
	ON container_type.container_type_id = all_containers.container_type_id
	WHERE all_containers.generic_container_id NOT IN (SELECT child_container_id FROM contents) AND
		all_containers.status = ''Active'' AND
		all_containers.identifier LIKE ''' + @identifier_filter + ''' AND
		container_type.name <> ''TopLevel'' AND
		container_type.name <> ''Uncontained'''

EXECUTE p_GetGenericContainers @select_command

END
