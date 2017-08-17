USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_QCRebuildDatabase]    Script Date: 11/20/2009 16:26:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_QCRebuildDatabase](@qcdb_id INTEGER, @wsetOffset INTEGER, @batchNumber INTEGER, @referenceDB VARCHAR(32))
AS
BEGIN

SET NOCOUNT ON

DECLARE @qcdbName VARCHAR(255)
DECLARE @tempProjId INTEGER
DECLARE @tempProjName VARCHAR(255)
DECLARE @errorMessage VARCHAR(255)
DECLARE @cmd VARCHAR(1500)
DECLARE @currentDbName VARCHAR(32)


DECLARE @projectQueue TABLE (projId INTEGER NOT NULL, projName VARCHAR(255) NOT NULL)


IF @qcdb_id IS NULL RETURN

SELECT @qcdbName = qcdb_name FROM qcdb WHERE qcdb_id = @qcdb_id

IF @qcdbName IS NULL RETURN

SELECT @currentDbName = db_name()

IF @currentDbName IS NULL RETURN

--
-- Store projects to copy.
--
INSERT INTO @projectQueue (projId, projName)
SELECT p.project_id, p.identifier
FROM project p
WHERE qcdb_id = @qcdb_id


--
-- Set the QCDB in restricted user mode.
--
SET @errorMessage = ''

INSERT INTO qcdb_rebuild_log (batch_number, qcdb_name, action, timepoint, message)
VALUES (@batchNumber, @qcdbName, 'Start set restricted user mode', GETDATE(), '')

SET @cmd = 'ALTER DATABASE ' + @qcdbName + ' SET RESTRICTED_USER WITH NO_WAIT'
EXEC (@cmd)

IF @@ERROR <> 0 SET @errorMessage = 'Unable to set restricted user mode.'

INSERT INTO qcdb_rebuild_log (batch_number, qcdb_name, action, timepoint, message)
VALUES (@batchNumber, @qcdbName, 'Finished set restricted user mode', GETDATE(), @errorMessage)	

IF @errorMessage <> ''
BEGIN
	RETURN	
END


--
-- Backsync the QCDB with the current database.
--
SET @errorMessage = ''

INSERT INTO qcdb_rebuild_log (batch_number, qcdb_name, action, timepoint, message)
VALUES (@batchNumber, @qcdbName, 'Start backsync', GETDATE(), '')

EXEC p_QCBacksync @qcdbName, @currentDbName, @errorMessage OUTPUT
			
INSERT INTO qcdb_rebuild_log (batch_number, qcdb_name, action, timepoint, message)
VALUES (@batchNumber, @qcdbName, 'Finished backsync', GETDATE(), @errorMessage)
	
IF @errorMessage <> ''
BEGIN
	RETURN	
END


--
-- Reset the QCDB
--
SET @errorMessage = ''

INSERT INTO qcdb_rebuild_log (batch_number, qcdb_name, action, timepoint, message)
VALUES (@batchNumber, @qcdbName, 'Start reset', GETDATE(), '')

EXEC p_QCReset @currentDbName, @referenceDB, @qcdbName, @errorMessage OUTPUT

INSERT INTO qcdb_rebuild_log (batch_number, qcdb_name, action, timepoint, message)
VALUES (@batchNumber, @qcdbName, 'Finished reset', GETDATE(), @errorMessage)

IF @errorMessage <> ''
BEGIN
	RETURN			
END




--
-- Fill data from each project.
--
WHILE EXISTS(SELECT * FROM @projectQueue)
BEGIN
	SET @errorMessage = ''

	SELECT TOP 1 @tempProjId = projId, @tempProjName = projName FROM @projectQueue

	INSERT INTO qcdb_rebuild_log (batch_number, qcdb_name, action, timepoint, message)
	VALUES (@batchNumber, @qcdbName, 'Start copy project ' + @tempProjName, GETDATE(), '')

	EXEC p_QCRefreshProject @tempProjId, @qcdbName, @referenceDB  

	IF @@ERROR <> 0 SET @errorMessage = 'Error when copying project.'
		
	INSERT INTO qcdb_rebuild_log (batch_number, qcdb_name, action, timepoint, message)
	VALUES (@batchNumber, @qcdbName, 'Finished copy project ' + @tempProjName, GETDATE(), @errorMessage)	

	DELETE FROM @projectQueue WHERE projId = @tempProjId
END



--
-- Insert workingset offset.
--
SET @errorMessage = ''	
	
INSERT INTO qcdb_rebuild_log (batch_number, qcdb_name, action, timepoint, message)
VALUES (@batchNumber, @qcdbName, 'Start insert workingset offset', GETDATE(), '')

EXEC p_QCInsertWsetOffset @qcdbName, @wsetOffset, @errorMessage OUTPUT
	
INSERT INTO qcdb_rebuild_log (batch_number, qcdb_name, action, timepoint, message)
VALUES (@batchNumber, @qcdbName, 'Finished insert workingset offset', GETDATE(), @errorMessage)	

--Do not continue to set multi-user mode if the workingset offset
--could not be inserted.		
IF @errorMessage <> ''
BEGIN
	RETURN			
END



--
-- Set the QCDB in multi-user mode.
--
INSERT INTO qcdb_rebuild_log (batch_number, qcdb_name, action, timepoint, message)
VALUES (@batchNumber, @qcdbName, 'Start set multi-user mode', GETDATE(), '')
	
SET @cmd = 'ALTER DATABASE ' + @qcdbName + ' SET MULTI_USER'
EXEC (@cmd)
	
IF @@ERROR <> 0
BEGIN
	INSERT INTO qcdb_rebuild_log (batch_number, qcdb_name, action, timepoint, message)
	VALUES (@batchNumber, @qcdbName, 'Finished set multi-user mode', GETDATE(), 'Unable to set multi-user mode.')	
END
ELSE
BEGIN
	INSERT INTO qcdb_rebuild_log (batch_number, qcdb_name, action, timepoint, message)
	VALUES (@batchNumber, @qcdbName, 'Finished set multi-user mode', GETDATE(), '')	
END
	

END

