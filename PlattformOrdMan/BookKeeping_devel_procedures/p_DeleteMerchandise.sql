USE [BookKeeping_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_DeleteMerchandise]    Script Date: 11/20/2009 16:10:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[p_DeleteMerchandise](
@id INTEGER
)

AS
BEGIN
SET NOCOUNT ON

DELETE FROM article_number WHERE merchandise_id = @id

DELETE FROM merchandise WHERE merchandise_id = @id

SET NOCOUNT OFF
END
