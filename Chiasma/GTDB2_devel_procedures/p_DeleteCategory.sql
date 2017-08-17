USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_DeleteState]    Script Date: 11/20/2009 15:46:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_DeleteCategory](@id SMALLINT)

AS
BEGIN
SET NOCOUNT ON

DELETE FROM category WHERE category_id = @id


SET NOCOUNT OFF
END
