USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetGenericContainerByBarcode]    Script Date: 11/20/2009 15:58:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_GetGenericContainerByBarcode] (@barcode VARCHAR(255))

AS
BEGIN

DECLARE @select_command VARCHAR (1024)

SET @select_command = 'SELECT generic_container_id FROM all_containers
				WHERE generic_container_id IN (SELECT identifiable_id FROM barcode
								WHERE code = ''' + @barcode + ''' AND kind = ''CONTAINER'')
				AND status = ''Active'''

EXECUTE p_GetGenericContainers @select_command

END
