USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetSamplesForInternalReport]    Script Date: 11/20/2009 16:01:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_GetSamplesForInternalReport](@id INTEGER)

AS
BEGIN
SET NOCOUNT ON

SELECT * FROM sample_view sv
	INNER JOIN internal_report_sample_stat irss ON irss.sample_id = sv.id
	INNER JOIN individual i ON sv.individual_id = i.individual_id
WHERE irss.internal_report_id = @id
AND i.individual_usage = 'Genotyping' order by sv.external_name


SET NOCOUNT OFF
END

