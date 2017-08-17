USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetSampleByTubeId]    Script Date: 11/20/2009 16:06:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE	 PROCEDURE [dbo].[p_GetSampleByTubeId]( @tube_id INTEGER )

AS
BEGIN
SET NOCOUNT ON

SELECT * FROM sample_view 
WHERE tube_id = @tube_id

SET NOCOUNT OFF
END
