USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetTubeHistory]    Script Date: 11/20/2009 16:09:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_GetTubeHistory](@id INTEGER)

AS
BEGIN
SET NOCOUNT ON

SELECT * from tube_history_view
WHERE id = @id
ORDER BY changed_date ASC

SET NOCOUNT OFF
END
