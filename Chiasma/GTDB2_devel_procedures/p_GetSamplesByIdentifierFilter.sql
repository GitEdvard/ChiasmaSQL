USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetSamplesByIdentifierFilter]    Script Date: 11/20/2009 16:06:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_GetSamplesByIdentifierFilter]( @identifier_filter VARCHAR (255) )

AS
BEGIN
SET NOCOUNT ON

SELECT * FROM sample_view
WHERE identifier LIKE @identifier_filter
ORDER BY identifier ASC

SET NOCOUNT OFF
END
