USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetPlateHistory]    Script Date: 11/20/2009 16:03:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_GetPlateHistory](@id INTEGER)

AS
BEGIN
SET NOCOUNT ON

SELECT * from plate_history_view
WHERE id = @id
ORDER BY changed_date ASC

SET NOCOUNT OFF
END
