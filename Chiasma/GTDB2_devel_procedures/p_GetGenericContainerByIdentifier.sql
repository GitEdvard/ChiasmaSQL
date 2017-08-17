USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetGenericContainerByIdentifier]    Script Date: 11/20/2009 15:59:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_GetGenericContainerByIdentifier] (@identifier VARCHAR(255))

AS
BEGIN

DECLARE @select_command VARCHAR (1024)

SET @select_command = 'SELECT generic_container_id FROM all_containers
				WHERE identifier = ''' + @identifier +
					''' AND status = ''Active'''

EXECUTE p_GetGenericContainers @select_command

END
