USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetInternalReportIndividualStatistics]    Script Date: 11/20/2009 16:01:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_GetInternalReportIndividualStatistics]( @id INTEGER )

AS
BEGIN
SET NOCOUNT ON

SELECT
	i.identifier AS individual,
	i.external_name,
	iris.success_rate,
	iris.dupl_fail,
	iris.dupl_test,
	iris.inh_fail,
	iris.inh_test
FROM internal_report_indv_stat iris
	INNER JOIN individual i ON i.individual_id = iris.individual_id 
WHERE iris.internal_report_id = @id

SET NOCOUNT OFF
END
