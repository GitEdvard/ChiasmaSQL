USE [BookKeeping_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_DeleteUser]    Script Date: 11/20/2009 16:09:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_DeleteUser](
@id INTEGER
)

AS
BEGIN
SET NOCOUNT ON

DELETE FROM authority WHERE authority_id = @id

SET NOCOUNT OFF
END
