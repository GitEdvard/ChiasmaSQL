USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_DeleteSampleSeriesGroup]    Script Date: 11/20/2009 15:45:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_DeleteSampleSeriesGroup] (@id INTEGER)

AS
BEGIN
SET NOCOUNT ON

-- Delete sample series group.
DELETE FROM sample_series_group
WHERE sample_series_group_id = @id

SET NOCOUNT OFF
END
