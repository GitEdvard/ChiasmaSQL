USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_QCBacksync]    Script Date: 11/20/2009 16:25:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_QCBacksync] (@sourceDB VARCHAR(255), @targetDB VARCHAR(255), @errorMessage VARCHAR(255) OUTPUT)
AS
BEGIN

SET NOCOUNT ON

CREATE TABLE #wset (wsetId INTEGER NOT NULL PRIMARY KEY,
					identifier VARCHAR(255) NOT NULL,
					wsetTypeId INTEGER NOT NULL,
					projectId INTEGER NULL,
					description VARCHAR(255) NULL,
					created DATETIME NOT NULL,
					authorityId INTEGER NOT NULL,
					deleted BIT NOT NULL
					)
					
CREATE TABLE #wsetMember (wsetId INTEGER NOT NULL,
						kindId TINYINT NOT NULL, 
						identifiableId INTEGER NOT NULL
						)					


CREATE TABLE #newWset (wsetId INTEGER NOT NULL PRIMARY KEY,
						wsetName VARCHAR(255) NOT NULL
						)

CREATE TABLE #conflictWset (name VARCHAR(255) NULL)

						
CREATE TABLE #updatedWsetType (wsetId INTEGER NOT NULL PRIMARY KEY,
								newWsetTypeId INTEGER NOT NULL
								)

CREATE TABLE #sessionSetting (sessionSettingId INTEGER NOT NULL PRIMARY KEY,
						keyName VARCHAR(255) NOT NULL,
						subkey VARCHAR(255) NOT NULL,
						valueChar VARCHAR(255) NULL,	
						valueInt INTEGER NULL,
						valueDec DECIMAL(10,2) NULL
						)

CREATE TABLE #newSessionSetting (sessionSettingId INTEGER NOT NULL PRIMARY KEY,
						keyName VARCHAR(255) NOT NULL,
						subkey VARCHAR(255) NOT NULL,
						valueChar VARCHAR(255) NULL,	
						valueInt INTEGER NULL,
						valueDec DECIMAL(10,2) NULL
						)

CREATE TABLE #allGenotypes (genotypeId INTEGER NOT NULL PRIMARY KEY,
						statusId TINYINT NOT NULL,
						lockedWsetId INTEGER NULL
						)

CREATE TABLE #changedGenotypeStatus (genotypeId INTEGER NOT NULL PRIMARY KEY,
						newStatusId TINYINT NOT NULL
						)

CREATE TABLE #changedGenotypeLock (genotypeId INTEGER NOT NULL PRIMARY KEY,
						newLockedWsetId INTEGER NULL
						)

CREATE TABLE #statusLog (statusLogId INTEGER NOT NULL PRIMARY KEY,
						genotypeId INTEGER NOT NULL,
						oldStatusId TINYINT NOT NULL, 
						newStatusId TINYINT NOT NULL,
						authorityId INTEGER NOT NULL, 
						created DATETIME NOT NULL
						)

CREATE TABLE #newStatusLog (statusLogId INTEGER NOT NULL PRIMARY KEY,
						genotypeId INTEGER NOT NULL,
						oldStatusId TINYINT NOT NULL, 
						newStatusId TINYINT NOT NULL,
						authorityId INTEGER NOT NULL, 
						created DATETIME NOT NULL
						)


DECLARE @cmd VARCHAR(1500)
DECLARE @useSource VARCHAR(24)
DECLARE @useTarget VARCHAR(24)
DECLARE @e INTEGER

SET @useSource = 'USE ' + @sourceDB + ' '
SET @useTarget = 'USE ' + @targetDB + ' '





--
-- Store all wsets from the source database.
--
SET @cmd = '
INSERT INTO #wset (wsetId, identifier, wsetTypeId, projectId, description, created, authorityId, deleted)
SELECT wset_id, identifier, wset_type_id, project_id, description, created, authority_id, deleted
FROM wset
'
EXEC (@useSource + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN SET @errorMessage = 'Error when getting wsets: ' + CAST(@e AS VARCHAR) RETURN -100 END

--
-- Store all wset members from the source database.
--
SET @cmd = '
INSERT INTO #wsetMember (wsetId, kindId, identifiableId)
SELECT wset_id, kind_id, identifiable_id
FROM wset_member
'
EXEC (@useSource + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN SET @errorMessage = 'Error when getting wset members: ' + CAST(@e AS VARCHAR) RETURN -100 END

--
-- Store all session_settings from the source database.
--
SET @cmd = '
INSERT INTO  #sessionSetting (sessionSettingId, keyName, subkey, valueChar, valueInt, valueDec)
SELECT session_setting_id, key_name, subkey, value_char, value_int, value_dec
FROM session_setting
'
EXEC (@useSource + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN SET @errorMessage = 'Error when getting gui values: ' + CAST(@e AS VARCHAR) RETURN -100 END

--
-- Store all genotype statuses from the source database.
--
SET @cmd = '
INSERT INTO #allGenotypes (genotypeId, statusId, lockedWsetId)
SELECT genotype_id, status_id, locked_wset_id
FROM denorm_genotype
'
EXEC (@useSource + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN SET @errorMessage = 'Error when getting genotype statuses: ' + CAST(@e AS VARCHAR) RETURN -100 END

--
-- Store all status log entries from the source database.
--
SET @cmd = '
INSERT INTO #statusLog (statusLogId, genotypeId, oldStatusId, newStatusId, authorityId, created)
SELECT sl.status_log_id, sl.genotype_id, sl.old_status_id, sl.new_status_id, sl.authority_id, sl.created 
FROM status_log sl
'
EXEC (@useSource + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN SET @errorMessage = 'Error when getting status log: ' + CAST(@e AS VARCHAR) RETURN -100 END

-- Check for wsets with the same name as in
-- the target database but with different timestamps,
-- i.e. wsets saved in the source database under a name
-- which already exists in the target database.
-- (It should however not be possible to save a session under the same
-- name as in the target database, because the whole gui_value
-- table is copied to the analysis database and the session_setting
-- table has a unique constraint on (key_name, subkey). But, wsets
-- with the same names could have been saved in two different
-- analysis databases.)
SET @cmd = '
INSERT INTO #conflictWset (name)
SELECT w.identifier FROM #wset w
INNER JOIN wset w_target ON w_target.identifier = w.identifier
AND NOT w_target.created = w.created
'
EXEC (@useTarget + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN SET @errorMessage = 'Error when checking for wset name conflicts: ' + CAST(@e AS VARCHAR) RETURN -100 END

IF EXISTS(SELECT * FROM #conflictWset) BEGIN SET @errorMessage = 'Wset name conflict.' RETURN -100 END


-- Find wsets which are not in the target database and which belong to a project.
SET @cmd = '
INSERT INTO #newWset (wsetId, wsetName)
SELECT w.wsetId AS wset_id, w.identifier AS wset_name
FROM #wset w
WHERE w.identifier NOT IN (SELECT target_w.identifier FROM wset target_w)
AND NOT w.projectId IS NULL
'
EXEC (@useTarget + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN SET @errorMessage = 'Error when extracting new wsets: ' + CAST(@e AS VARCHAR) RETURN -100 END

-- Find wsets which have had their type updated (unlocking of approved sessions)
SET @cmd = '
INSERT INTO #updatedWsetType (wsetId, newWsetTypeId)
SELECT w.wsetId, w.wsetTypeId
FROM #wset w
INNER JOIN wset target_w ON target_w.wset_id = w.wsetId AND NOT target_w.wset_type_id = w.wsetTypeId
'
EXEC (@useTarget + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN SET @errorMessage = 'Error when finding wsets with updated types: ' + CAST(@e AS VARCHAR) RETURN -100 END


-- Find changed genotype statuses
SET @cmd = '
INSERT INTO #changedGenotypeStatus (genotypeId, newStatusId)
SELECT ag.genotypeId, ag.statusId
FROM #allGenotypes ag
LEFT OUTER JOIN genotype g ON g.genotype_id = ag.genotypeId AND g.status_id = ag.statusId
WHERE g.genotype_id IS NULL
'
EXEC (@useTarget + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN SET @errorMessage = 'Error when extracting new genotype statuses: ' + CAST(@e AS VARCHAR) RETURN -100 END


-- Find changed genotype locks
SET @cmd = '
INSERT INTO #changedGenotypeLock (genotypeId, newLockedWsetId)
SELECT ag.genotypeId, ag.lockedWsetId
FROM #allGenotypes ag
INNER JOIN genotype g ON (g.genotype_id = ag.genotypeId AND g.locked_wset_id IS NULL AND (NOT ag.lockedWsetId IS NULL))
UNION
SELECT ag.genotypeId, ag.lockedWsetId
FROM #allGenotypes ag
INNER JOIN genotype g ON (g.genotype_id = ag.genotypeId AND (NOT g.locked_wset_id IS NULL) AND ag.lockedWsetId IS NULL)
UNION
SELECT ag.genotypeId, ag.lockedWsetId
FROM #allGenotypes ag
INNER JOIN genotype g ON (g.genotype_id = ag.genotypeId AND (NOT g.locked_wset_id = ag.lockedWsetId) AND (NOT g.locked_wset_id IS NULL) AND (NOT ag.lockedWsetId IS NULL)) 
'
EXEC (@useTarget + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN SET @errorMessage = 'Error when extracting new locks: ' + CAST(@e AS VARCHAR) RETURN -100 END




-- Find new status log entries.
SET @cmd = '
INSERT INTO #newStatusLog (statusLogId, genotypeId, oldStatusId, newStatusId, authorityId, created)
SELECT source_sl.statusLogId, source_sl.genotypeId, source_sl.oldStatusId, source_sl.newStatusId, source_sl.authorityId, source_sl.created
FROM #statusLog source_sl
LEFT OUTER JOIN genotype_log target_sl on target_sl.genotype_id = source_sl.genotypeId AND target_sl.performed = source_sl.created
WHERE target_sl.genotype_id IS NULL
AND source_sl.genotypeId IN (SELECT genotype_id FROM genotype)  --The results could have been deleted.
'
EXEC (@useTarget + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN SET @errorMessage = 'Error when extracting new status log entries: ' + CAST(@e AS VARCHAR) RETURN -100 END




-- Find new session settings
SET @cmd = '
INSERT INTO #newSessionSetting (sessionSettingId, keyName, subKey, valueChar, valueInt, valueDec)
SELECT source_ss.sessionSettingId, source_ss.keyName, source_ss.subkey, source_ss.valueChar, source_ss.valueInt, source_ss.valueDec
FROM #sessionSetting source_ss
LEFT OUTER JOIN gui_value target_gv ON target_gv.key_name = source_ss.keyName AND target_gv.subkey = source_ss.subkey
WHERE target_gv.key_name IS NULL
'
EXEC (@useTarget + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN SET @errorMessage = 'Error when extracting new session setting values: ' + CAST(@e AS VARCHAR) RETURN -100 END






BEGIN TRANSACTION

-- Copy all new wsets
SET @cmd = '
DECLARE @tempSourceWsetId INTEGER
DECLARE @tempTargetWsetId INTEGER
DECLARE @tempTargetWsetName VARCHAR(255)
DECLARE @wsetKindId INTEGER

SELECT @wsetKindId = kind_id FROM kind WHERE name = ''WSET''

WHILE EXISTS(SELECT * FROM #newWset)
BEGIN
	SELECT TOP 1 @tempSourceWsetId = wsetId, @tempTargetWsetName = wsetName FROM #newWset
	
	-- Copy the wset.
	INSERT INTO wset (identifier, project_id, authority_id, wset_type_id, created, description, deleted)
	SELECT identifier, projectId, authorityId, wsetTypeId, created, description, deleted
	FROM #wset
	WHERE wsetId = @tempSourceWsetId
	
	-- Get the ID of the created wset.
	SELECT @tempTargetWsetId = wset_id FROM wset WHERE identifier = @tempTargetWsetName
	
	-- Copy the wset members.	
	INSERT INTO wset_member (wset_id, kind_id, identifiable_id)
	SELECT @tempTargetWsetId, wm.kindId, wm.identifiableId
	FROM #wsetMember wm
	WHERE wm.wsetId = @tempSourceWsetId
		
	-- Change the wset reference for locks to the new ID.
	UPDATE #changedGenotypeLock SET newLockedWsetId = @tempTargetWsetId WHERE newLockedWsetId = @tempSourceWsetId
		
	DELETE FROM #newWset WHERE wsetId = @tempSourceWsetId
END
'
EXEC (@useTarget + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN ROLLBACK TRANSACTION SET @errorMessage = 'Error when storing wsets: ' + CAST(@e AS VARCHAR) RETURN -100 END

-- Update wset deletions.
SET @cmd = '
UPDATE wset SET deleted = 1
FROM wset target_w
INNER JOIN #wset source_w ON source_w.wsetId = target_w.wset_id
WHERE target_w.deleted = 0 AND source_w.deleted = 1 
'
EXEC (@useTarget + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN ROLLBACK TRANSACTION SET @errorMessage = 'Error when updating wset types: ' + CAST(@e AS VARCHAR) RETURN -100 END



-- Update changed wset types
SET @cmd = '
UPDATE wset SET wset_type_id = uwt.newWsetTypeId
FROM wset w
INNER JOIN #updatedWsetType uwt ON uwt.wsetId = w.wset_id
'
EXEC (@useTarget + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN ROLLBACK TRANSACTION SET @errorMessage = 'Error when updating wset types: ' + CAST(@e AS VARCHAR) RETURN -100 END


-- Copy all new entries in the session_setting table
SET @cmd = '
INSERT INTO gui_value (key_name, subkey, value_char, value_int, value_dec)
SELECT new_ss.keyName, new_ss.subkey, new_ss.valueChar, new_ss.valueInt, new_ss.valueDec
FROM #newSessionSetting new_ss
LEFT OUTER JOIN gui_value target_gv ON target_gv.key_name = new_ss.keyName AND target_gv.subkey = new_ss.subkey
WHERE target_gv.key_name IS NULL
'
EXEC (@useTarget + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN ROLLBACK TRANSACTION SET @errorMessage = 'Error when storing gui values: ' + CAST(@e AS VARCHAR) RETURN -100 END


-- Perform status changes.
SET @cmd = '
UPDATE genotype SET status_id = cg.newStatusId
FROM genotype g
INNER JOIN #changedGenotypeStatus cg ON cg.genotypeId = g.genotype_id
'
EXEC (@useTarget + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN ROLLBACK TRANSACTION SET @errorMessage = 'Error when performing status changes: ' + CAST(@e AS VARCHAR) RETURN -100 END


-- Perform lock changes.
SET @cmd = '
UPDATE genotype SET locked_wset_id = cgl.newLockedWsetId
FROM genotype g
INNER JOIN #changedGenotypeLock cgl ON cgl.genotypeId = g.genotype_id
'
EXEC (@useTarget + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN ROLLBACK TRANSACTION SET @errorMessage = 'Error when performing lock changes: ' + CAST(@e AS VARCHAR) RETURN -100 END


-- Insert status log entries.
SET @cmd = '
INSERT INTO genotype_log (genotype_id, data_modified, old_value, new_value, performed, authority_id)
SELECT nsl.genotypeId, ''status_id'', nsl.oldStatusId, nsl.newStatusId, created, authorityId
FROM #newStatusLog nsl
'
EXEC (@useTarget + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN ROLLBACK TRANSACTION SET @errorMessage = 'Error when inserting status log entries: ' + CAST(@e AS VARCHAR) RETURN -100 END

COMMIT TRANSACTION

SET NOCOUNT OFF

END

