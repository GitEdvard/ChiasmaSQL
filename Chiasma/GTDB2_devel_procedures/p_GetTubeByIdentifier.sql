USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetTubeByIdentifier]    Script Date: 11/20/2009 16:08:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_GetTubeByIdentifier](@identifier VARCHAR(255))

AS
BEGIN
SET NOCOUNT ON

SELECT * FROM tube_view 
WHERE identifier = @identifier

SET NOCOUNT OFF
END
