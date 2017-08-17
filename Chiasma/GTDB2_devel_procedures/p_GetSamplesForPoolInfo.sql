USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetSamplesForPoolInfo]    Script Date: 11/20/2009 15:54:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_GetSamplesForPoolInfo](@id INTEGER)

AS
BEGIN
SET NOCOUNT ON

SELECT * FROM sample_view
WHERE pool_info_for_samples_id = @id

SET NOCOUNT OFF
END
