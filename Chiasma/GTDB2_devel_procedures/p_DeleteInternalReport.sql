USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_DeleteInternalReport]    Script Date: 11/20/2009 15:44:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_DeleteInternalReport](@id INTEGER)

--Deletes the specified internal report and all its related data.

AS 
BEGIN
SET NOCOUNT ON
SET ARITHABORT ON 
DECLARE @unit VARCHAR(255)

select @unit = item_unit from internal_report WHERE internal_report_id = @id

--Delete genotype results.
IF @unit = 'individual'
	DELETE FROM internal_report_result WHERE internal_report_id = @id
ELSE
	DELETE FROM internal_report_result_sample_ref WHERE internal_report_id = @id

--Delete marker statistics.
DELETE FROM internal_report_marker_stat
WHERE internal_report_id = @id

--Delete item statistics.
IF @unit = 'individual'
	DELETE FROM internal_report_indv_stat WHERE internal_report_id = @id
ELSE
	DELETE FROM internal_report_sample_stat WHERE internal_report_id = @id

--Delete result plate information.
DELETE FROM internal_report_result_plate
WHERE internal_report_id = @id

--Finally delete the internal report main object.
DELETE FROM internal_report
WHERE internal_report_id = @id


SET NOCOUNT OFF
END
