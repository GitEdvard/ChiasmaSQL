USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetPlateById]    Script Date: 11/20/2009 16:02:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[p_GetPlateById](@id INTEGER)

AS
BEGIN
SET NOCOUNT ON

SELECT * from plate_view 
WHERE id = @id
SET NOCOUNT OFF

END
