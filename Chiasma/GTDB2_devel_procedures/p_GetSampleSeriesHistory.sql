USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetSampleSeriesHistory]    Script Date: 11/20/2009 16:07:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_GetSampleSeriesHistory]( @id INTEGER )

AS
BEGIN
SET NOCOUNT ON

SELECT 
	sample_series_id AS id,
	identifier,
	comment,
	changed_date,
	changed_authority_id,
	changed_action 
FROM sample_series_history
WHERE sample_series_id = @id
ORDER BY changed_date ASC

SET NOCOUNT OFF
END
