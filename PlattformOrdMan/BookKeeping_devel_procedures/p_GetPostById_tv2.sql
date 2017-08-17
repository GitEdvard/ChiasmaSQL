USE [BookKeeping_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetPostById_tv2]    Script Date: 11/20/2009 16:10:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[p_GetPostById_tv2](
@id INTEGER)

AS
BEGIN
SET NOCOUNT ON

SELECT * from post_table_version_2_view
WHERE id = @id

SET NOCOUNT OFF
END
