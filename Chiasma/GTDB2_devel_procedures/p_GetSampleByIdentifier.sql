USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetSampleByIdentifier]    Script Date: 11/20/2009 16:06:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_GetSampleByIdentifier]( @identifier VARCHAR (255) )

AS
BEGIN
SET NOCOUNT ON

SELECT * FROM sample_view 
WHERE identifier = @identifier

SET NOCOUNT OFF
END

