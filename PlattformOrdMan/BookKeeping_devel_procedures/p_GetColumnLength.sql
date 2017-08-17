USE [BookKeeping_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetColumnLength]    Script Date: 11/20/2009 15:56:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_GetColumnLength] (
	@table VARCHAR(255),
	@column VARCHAR(255))

AS
BEGIN
SET NOCOUNT ON

SELECT COL_LENGTH(@table, @column) AS 'column_length'

SET NOCOUNT OFF
END
