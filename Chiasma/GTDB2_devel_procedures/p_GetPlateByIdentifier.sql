USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetPlateByIdentifier]    Script Date: 11/20/2009 16:02:47 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[p_GetPlateByIdentifier](@identifier VARCHAR(255))

AS
BEGIN
SET NOCOUNT ON

SELECT * from plate_view 
WHERE identifier = @identifier
SET NOCOUNT OFF

END
