USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetSampleById]    Script Date: 11/20/2009 16:06:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_GetSampleById]( @id INTEGER )

-- Test 1

-- Test 2

AS
BEGIN
SET NOCOUNT ON

SELECT * FROM sample_view 
WHERE id = @id

SET NOCOUNT OFF
END
