USE [BookKeeping_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_DeletePost_tv1]    Script Date: 11/20/2009 16:10:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_DeletePost_tv1](
@id INTEGER
)

AS
BEGIN
SET NOCOUNT ON

DELETE FROM post_table_version_1 WHERE post_id = @id

SET NOCOUNT OFF
END
