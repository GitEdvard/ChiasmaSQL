USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_ExportGenotypesGetGenotypesForInternalReport]    Script Date: 11/20/2009 15:54:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_ExportGenotypesGetGenotypesForInternalReport] (@internal_report_id INTEGER, @file_path VARCHAR(255), @format_file_path VARCHAR(255))

AS
BEGIN
SET NOCOUNT ON

DECLARE @is_bulk BIT
DECLARE @cmd VARCHAR(512)
declare @is_sample_report bit

SET @is_bulk = NULL
SET @is_sample_report = NULL

SELECT @is_bulk = is_bulk FROM internal_report
WHERE internal_report_id = @internal_report_id

IF @is_bulk IS NULL
BEGIN
	RAISERROR('Unable to find bulk status for internal report with id %d', 15, 1, @internal_report_id)
	RETURN	
END

select @is_sample_report = case item_unit 
	when 'individual' then
		0
	else
		1
	end
from internal_report 
where internal_report_id = @internal_report_id

IF @is_sample_report IS NULL
BEGIN
	RAISERROR('Unable to find bulk status for internal report with id %d', 15, 1, @internal_report_id)
	RETURN	
END


IF @is_bulk > 0
BEGIN
	SET @cmd = 'SELECT gtf.individual_id, gtf.marker_id, gtf.top_allele_result_id '
	+ 'FROM OPENROWSET(BULK ''' + @file_path + ''', '
	+ 'FIRSTROW = 2, FORMATFILE = ''' + @format_file_path + ''') AS gtf'

	EXEC(@cmd)
END
ELSE
BEGIN
	if @is_sample_report = 1
	begin
		SELECT sample_id as individual_id, marker_id, top_allele_result_id -- dirty fix with individual_id
		FROM internal_report_result_sample_ref
		WHERE internal_report_id = @internal_report_id		
	end	
	else
	begin
		SELECT individual_id, marker_id, top_allele_result_id
		FROM internal_report_result
		WHERE internal_report_id = @internal_report_id
	end
END


SET NOCOUNT OFF
END
