USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetPoolNumbersForSampleSeries]    Script Date: 11/20/2009 15:54:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_GetPoolNumbersForSampleSeries](@sample_series_id INTEGER)

AS
BEGIN
SET NOCOUNT ON

SELECT pifa.pool_number as pool_number from pool_info_for_aliquots pifa
where pifa.sample_series_id = @sample_series_id
union
SELECT pifs.pool_number as pool_number from pool_info_for_samples pifs
where pifs.sample_series_id = @sample_series_id

SET NOCOUNT OFF
END
