USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetGenericContainersByIdentifierFilter]    Script Date: 11/20/2009 15:59:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_GetGenericContainersByIdentifierFilter] (
	@identifier_filter VARCHAR(255),
	@active_containers BIT)

AS
BEGIN

DECLARE @container_status VARCHAR(32)
DECLARE @select_command VARCHAR (1024)

IF @active_containers = 1
BEGIN
	SET @container_status = 'Active'
END
ELSE
BEGIN
	SET @container_status = 'Disposed'
END

SET @select_command = 'SELECT generic_container_id FROM all_containers
	WHERE status = ''' + @container_status + ''' AND identifier LIKE ''' + @identifier_filter + ''''

EXECUTE p_GetGenericContainers @select_command

END
