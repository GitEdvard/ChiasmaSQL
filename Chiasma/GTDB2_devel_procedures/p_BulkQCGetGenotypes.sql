USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_BulkQCGetGenotypes]    Script Date: 11/16/2009 13:32:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_BulkQCGetGenotypes](@result_plate_id INTEGER, @file_path VARCHAR(255), @format_file_path VARCHAR(255))
AS
BEGIN
SET NOCOUNT ON

DECLARE @is_bulk BIT
DECLARE @cmd VARCHAR(512)

SET @is_bulk = NULL

SELECT @is_bulk = gtm.is_bulk FROM result_plate rp
	INNER JOIN gt_method gtm ON gtm.gt_method_id = rp.gt_method_id
WHERE rp.result_plate_id = @result_plate_id

IF @is_bulk IS NULL
BEGIN
	RAISERROR('Unable to find bulk status for result plate with id %d', 15, 1, @result_plate_id)
	RETURN	
END

IF @is_bulk > 0
BEGIN
	SET @cmd = 'SELECT gtf.sample_id, gtf.marker_id, gtf.allele_result_id, gtf.strand '
	+ 'FROM OPENROWSET(BULK ''' + @file_path + ''', '
	+ 'FIRSTROW = 2, FORMATFILE = ''' + @format_file_path + ''') AS gtf'

	EXEC(@cmd)
END
ELSE
BEGIN
	SELECT gt.sample_id, a.marker_id, gt.allele_result_id, dbo.fDetermineTopBot(a.assay_id) AS strand
	FROM genotype gt
	INNER JOIN assay a ON a.assay_id = gt.assay_id
	WHERE gt.result_plate_id = @result_plate_id
END

SET NOCOUNT OFF
END
