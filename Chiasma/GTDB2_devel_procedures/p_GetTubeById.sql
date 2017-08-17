USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetTubeById]    Script Date: 11/20/2009 16:08:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_GetTubeById](@id INTEGER)

AS
BEGIN
SET NOCOUNT ON

SELECT * FROM tube_view 
WHERE id = @id

SET NOCOUNT OFF
END
