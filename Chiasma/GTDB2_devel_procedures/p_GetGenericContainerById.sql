USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetGenericContainerById]    Script Date: 11/20/2009 15:58:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_GetGenericContainerById] (@id INTEGER)

AS
BEGIN

DECLARE @select_command VARCHAR (1024)

SET @select_command = 'SELECT generic_container_id = ' + STR(@id)

EXECUTE p_GetGenericContainers @select_command

END
