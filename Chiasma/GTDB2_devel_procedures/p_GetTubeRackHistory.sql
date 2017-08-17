USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetTubeRackHistory]    Script Date: 11/20/2009 16:09:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_GetTubeRackHistory](@id INTEGER)

AS
BEGIN
SET NOCOUNT ON

SELECT * from tube_rack_history_view
WHERE id = @id
ORDER BY changed_date ASC

SET NOCOUNT OFF
END
