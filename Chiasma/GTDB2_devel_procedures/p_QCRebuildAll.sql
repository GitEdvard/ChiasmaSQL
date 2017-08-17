USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_QCRebuildAll]    Script Date: 11/20/2009 16:26:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_QCRebuildAll](@referenceDB VARCHAR(32))
AS
BEGIN

SET NOCOUNT ON

DECLARE @qcdbQueue TABLE (qcdbId INTEGER NOT NULL PRIMARY KEY)

DECLARE @tempQcdbId INTEGER
DECLARE @errorMessage VARCHAR(255)
DECLARE @batchNumber INTEGER
DECLARE @qcdbWsetOffset INTEGER
DECLARE @qcdbWsetOffsetStep INTEGER


--
-- Store names of QCDBs to set in restricted user mode.
--
INSERT INTO @qcdbQueue (qcdbId)
SELECT qcdb_id FROM qcdb


--
-- Start batch.
--
INSERT INTO qcdb_rebuild_batch (start_time)
VALUES (GETDATE())

SET @batchNumber = SCOPE_IDENTITY()

SET @qcdbWsetOffset = 2000000000  --A large number but substantially less than the maximum for integer.
SET @qcdbWsetOffsetStep = 10000  --The number used to separate the offsets for each QC database.

WHILE EXISTS(SELECT * FROM @qcdbQueue)
BEGIN
	SET @errorMessage = ''

	SELECT TOP 1 @tempQcdbId = qcdbId FROM @qcdbQueue

	EXEC p_QCRebuildDatabase @tempQcdbId, @qcdbWsetOffset, @batchNumber, @referenceDB  

	DELETE FROM @qcdbQueue WHERE qcdbId = @tempQcdbId

	SET @qcdbWsetOffset = @qcdbWsetOffset + @qcdbWsetOffsetStep
END


--
-- Finish batch.
--
UPDATE qcdb_rebuild_batch SET end_time = GETDATE() WHERE batch_number = @batchNumber

SET NOCOUNT OFF


--
-- Check for errors.
--
IF EXISTS(SELECT * FROM qcdb_rebuild_log WHERE batch_number = @batchNumber AND message <> '') 
BEGIN
	RAISERROR('An error occurred during execution of complete update.', 11, 1)
END

END


