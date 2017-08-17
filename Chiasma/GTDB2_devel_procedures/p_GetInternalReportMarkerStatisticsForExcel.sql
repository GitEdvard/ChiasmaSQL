USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetInternalReportMarkerStatisticsForExcel]    Script Date: 11/20/2009 16:01:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_GetInternalReportMarkerStatisticsForExcel]( 
@id INTEGER,
@strand_reference VARCHAR(20)
)

AS
BEGIN
SET NOCOUNT ON

DECLARE @is_bulk AS BIT

SELECT @is_bulk = is_bulk FROM internal_report WHERE internal_report_id = @id

IF @strand_reference = 'TOP'
BEGIN
	SELECT
		m.identifier 
			AS marker,
		irms.XX,
		irms.YY,
		irms.XY,
		irms.NA,
		dbo.fGetXAlleleTop(irms.marker_id, @is_bulk) as XAllele,
		dbo.fGetYAlleleTop(irms.marker_id, @is_bulk) as YAllele,
		CASE WHEN (irms.XX + irms.YY + irms.XY + irms.NA)>0 THEN CAST(irms.XX + irms.YY + irms.XY AS DECIMAL(9,3)) / CAST(irms.XX + irms.YY + irms.XY + irms.NA AS DECIMAL(9,3)) ELSE NULL END 
			AS success_rate,
		dbo.fHWChi2(@id, irms.marker_id) 
			AS HWChi2,
		irms.dupl_fail,
		irms.dupl_test,
		CASE WHEN (irms.XX + irms.YY + irms.XY + irms.NA) > 0 THEN CAST(irms.dupl_test AS DECIMAL(9, 3))/CAST(irms.XX + irms.YY + irms.XY + irms.NA AS DECIMAL(9, 3)) ELSE NULL END 
			AS validation,
		CASE WHEN irms.dupl_test > 0 THEN 1.0 - CAST(irms.dupl_fail AS DECIMAL(9, 3))/CAST(irms.dupl_test AS DECIMAL(9, 3)) ELSE NULL END 
			AS reproducibility,
		irms.inh_fail,
		irms.inh_test,
		irms.ctrl_inh_fail,
		irms.ctrl_inh_test,
		ISNULL(irms.comment, '') AS comment
	FROM internal_report_marker_stat irms
		INNER JOIN marker m ON m.marker_id = irms.marker_id 
	WHERE irms.internal_report_id = @id
END
ELSE
BEGIN
SELECT
	m.identifier 
		AS marker,
	dbo.fGetXX(@id, irms.marker_id, irms.XX, irms.YY, @strand_reference) as XX,
	dbo.fGetYY(@id, irms.marker_id, irms.XX, irms.YY, @strand_reference) as YY,
	irms.XY,
	irms.NA,
	dbo.fGetXAllele(irms.marker_id, @is_bulk, @strand_reference) as XAllele,
	dbo.fGetYAllele(irms.marker_id, @is_bulk, @strand_reference) as YAllele,	
	CASE WHEN (irms.XX + irms.YY + irms.XY + irms.NA)>0 THEN CAST(irms.XX + irms.YY + irms.XY AS DECIMAL(9,3)) / CAST(irms.XX + irms.YY + irms.XY + irms.NA AS DECIMAL(9,3)) ELSE NULL END 
		AS success_rate,
	dbo.fHWChi2(@id, irms.marker_id) 
		AS HWChi2,
	irms.dupl_fail,
	irms.dupl_test,
	CASE WHEN (irms.XX + irms.YY + irms.XY + irms.NA) > 0 THEN CAST(irms.dupl_test AS DECIMAL(9, 3))/CAST(irms.XX + irms.YY + irms.XY + irms.NA AS DECIMAL(9, 3)) ELSE NULL END 
		AS validation,
	CASE WHEN irms.dupl_test > 0 THEN 1.0 - CAST(irms.dupl_fail AS DECIMAL(9, 3))/CAST(irms.dupl_test AS DECIMAL(9, 3)) ELSE NULL END 
		AS reproducibility,
	irms.inh_fail,
	irms.inh_test,
	irms.ctrl_inh_fail,
	irms.ctrl_inh_test,
	ISNULL(irms.comment, '') AS comment
FROM internal_report_marker_stat irms
	INNER JOIN marker m ON m.marker_id = irms.marker_id 
WHERE irms.internal_report_id = @id

END

SET NOCOUNT OFF
END
