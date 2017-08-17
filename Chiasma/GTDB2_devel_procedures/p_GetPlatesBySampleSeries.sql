USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetPlatesBySampleSeries]    Script Date: 11/20/2009 16:03:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[p_GetPlatesBySampleSeries] (
	@sample_series_id int, 
	@include_disposed_plates BIT)

AS
BEGIN
SET NOCOUNT ON

-- Get plates.
SELECT * from plate_view 
WHERE sample_series_id = @sample_series_id AND
	(status = 'Active' OR @include_disposed_plates = 1)

SET NOCOUNT OFF
END
