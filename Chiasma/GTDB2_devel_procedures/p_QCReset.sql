USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_QCReset]    Script Date: 11/20/2009 16:26:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_QCReset](@sourceDB VARCHAR(20), @referenceDB VARCHAR(20), @targetDB VARCHAR(20), @errorMessage VARCHAR(255) OUTPUT)
AS
BEGIN

CREATE TABLE #individual (
	individual_id		INTEGER NOT NULL PRIMARY KEY NONCLUSTERED,
	identifier		VARCHAR(255) NOT NULL UNIQUE,
	individual_type_id	TINYINT NOT NULL,
	father_id		INTEGER NULL,
	mother_id		INTEGER NULL,
	sex_id			TINYINT NOT NULL  
)

CREATE TABLE #individual_type (
	individual_type_id		TINYINT NOT NULL PRIMARY KEY IDENTITY(1,1),  --Using an identity column only in the temporary table to create a primary key.
	name		VARCHAR(255) NOT NULL UNIQUE 
)

CREATE TABLE #sex (
	sex_id			TINYINT NOT NULL PRIMARY KEY,
	name			VARCHAR(255) NOT NULL UNIQUE
)

CREATE TABLE #sample (
	sample_id		INTEGER NOT NULL PRIMARY KEY NONCLUSTERED,
	identifier		VARCHAR(255) NOT NULL UNIQUE,
	individual_id		INTEGER NOT NULL
)

CREATE TABLE #wset_type (
	wset_type_id	INTEGER NOT NULL PRIMARY KEY,
	name			VARCHAR(255) NOT NULL UNIQUE,
	description		VARCHAR(255) NULL
)

CREATE TABLE #kind (
	kind_id		TINYINT NOT NULL PRIMARY KEY,
	name		VARCHAR(255) NOT NULL UNIQUE
)

CREATE TABLE #status (
	status_id	INTEGER NOT NULL,
	name		VARCHAR(20) NOT NULL		
)

CREATE TABLE #session_setting (
	session_setting_id	INTEGER NOT NULL PRIMARY KEY IDENTITY(1,1),
	key_name		VARCHAR(255) NOT NULL,
	subkey			VARCHAR(255) NOT NULL,
	value_char		VARCHAR(255) NULL,	
	value_int		INTEGER NULL,
	value_dec		DECIMAL(10,2) NULL,
	UNIQUE (key_name, subkey)
)

CREATE TABLE #authority (
	authority_id	INTEGER NOT NULL PRIMARY KEY,
	identifier		VARCHAR(255) NOT NULL UNIQUE,
	name			VARCHAR(255) NOT NULL,
	user_type		VARCHAR(32) NOT NULL,
	account_status	BIT NOT NULL
)

CREATE TABLE #annotation_type ( 
	annotation_type_id INTEGER NOT NULL PRIMARY KEY IDENTITY(1,1),
	identifier		VARCHAR(255) NOT NULL UNIQUE,
	description		VARCHAR(255) NULL
)

CREATE TABLE #reference_set (
	reference_set_id	TINYINT NOT NULL PRIMARY KEY,
	identifier		VARCHAR(255) NOT NULL UNIQUE
)


DECLARE @cmd VARCHAR(1500)
DECLARE @useSource VARCHAR(24)
DECLARE @useReference VARCHAR(24)
DECLARE @useTarget VARCHAR(24)
DECLARE @e INTEGER

SET NOCOUNT ON



SET @useSource = 'USE ' + @sourceDB + ' '
SET @useReference = 'USE ' + @referenceDB + ' '
SET @useTarget = 'USE ' + @targetDB + ' '

---------------------------------------- Clear target database -------------------------------------
BEGIN TRANSACTION

SET @cmd = '
DELETE FROM session_setting
DELETE FROM wset_member
DELETE FROM kind
DELETE FROM wset
DELETE FROM wset_type
DELETE FROM status_log
DELETE FROM denorm_genotype
DELETE FROM sample
DELETE FROM individual
DELETE FROM individual_type
DELETE FROM sex
DELETE FROM assay
DELETE FROM annotation_link
DELETE FROM annotation
DELETE FROM marker
DELETE FROM annotation_type
DELETE FROM plate
DELETE FROM authority
DELETE FROM status
DELETE FROM reference_genotype
DELETE FROM reference_set
DELETE FROM permission
DELETE FROM project
'
EXEC (@useTarget + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN ROLLBACK TRANSACTION SET @errorMessage = 'Error when clearing target database: ' + CAST(@e AS VARCHAR) RETURN -100 END

COMMIT TRANSACTION

---------------------------------------- Reset identity seeds ------------------------------------
SET @cmd = '
DBCC CHECKIDENT(''session_setting'', RESEED, 0)
DBCC CHECKIDENT(''status_log'', RESEED, 0)
DBCC CHECKIDENT(''annotation'', RESEED, 0)
DBCC CHECKIDENT(''annotation_type'', RESEED, 0)
'
EXEC (@useTarget + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN SET @errorMessage = 'Error when resetting identity seeds: ' + CAST(@e AS VARCHAR) RETURN -100 END

-------------------------------- Read general information from source database -------------------


--
-- Read kinds.
--
SET @cmd = '
INSERT INTO #kind (kind_id, name)
SELECT k.kind_id, k.name
FROM dbo.kind k
'
EXEC (@useSource + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN SET @errorMessage = 'Error when reading kinds: ' + CAST(@e AS VARCHAR) RETURN -100 END


--
-- Read wset types.
--
SET @cmd = '
INSERT INTO #wset_type (wset_type_id, name, description)
SELECT wtc.wset_type_id, wtc.name, wtc.description
FROM dbo.wset_type_code wtc
'
EXEC (@useSource + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN SET @errorMessage = 'Error when reading wset types: ' + CAST(@e AS VARCHAR) RETURN -100 END

--
-- Read statuses.
--
SET @cmd = '
INSERT INTO #status (status_id, name)
SELECT sc.status_id, sc.name
FROM dbo.status_code sc
'
EXEC (@useSource + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN SET @errorMessage = 'Error when reading status codes: ' + CAST(@e AS VARCHAR) RETURN -100 END

--
-- Read sex codes.
--
SET @cmd = '
INSERT INTO #sex (sex_id, name)
SELECT CAST(sx.sex AS TINYINT), sx.name
FROM dbo.sex_code sx
'
EXEC (@useSource + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN SET @errorMessage = 'Error when reading sex codes: ' + CAST(@e AS VARCHAR) RETURN -100 END

--
-- Read individual types.
--
SET @cmd = '
INSERT INTO #individual_type (name)
SELECT DISTINCT individual_usage
FROM dbo.individual
'
EXEC (@useSource + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN SET @errorMessage = 'Error when reading individual types: ' + CAST(@e AS VARCHAR) RETURN -100 END

--
-- Read authorities.
--
SET @cmd = '
INSERT INTO #authority (authority_id, identifier, name, user_type, account_status)
SELECT a.authority_id, a.identifier, a.name, a.user_type, a.account_status
FROM dbo.authority a
'
EXEC (@useSource + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN SET @errorMessage = 'Error when reading authorities: ' + CAST(@e AS VARCHAR) RETURN -100 END

--
-- Read control individuals.
--
SET @cmd = '
INSERT INTO #individual (individual_id, identifier, individual_type_id, father_id, mother_id, sex_id)
SELECT idv.individual_id, idv.identifier, idt.individual_type_id, idv.father_id, idv.mother_id, idv.sex
FROM dbo.individual idv
INNER JOIN #individual_type idt ON idt.name = idv.individual_usage
WHERE idt.name = ''BlankControl'' OR idt.name = ''InheritanceControl'' OR idt.name = ''HomozygoteControl''
'
EXEC (@useSource + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN SET @errorMessage = 'Error when reading control individuals: ' + CAST(@e AS VARCHAR) RETURN -100 END


--
-- Read control samples.
--
SET @cmd = '
INSERT INTO #sample (sample_id, identifier, individual_id)
SELECT smp.sample_id, smp.identifier, smp.individual_id
FROM dbo.sample smp
INNER JOIN dbo.individual idv ON idv.individual_id = smp.individual_id
INNER JOIN #individual_type idt ON idt.name = idv.individual_usage
WHERE idt.name = ''BlankControl'' OR idt.name = ''InheritanceControl'' OR idt.name = ''HomozygoteControl''
'
EXEC (@useSource + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN SET @errorMessage = 'Error when reading control samples: ' + CAST(@e AS VARCHAR) RETURN -100 END

--
-- Read reference sets if a reference database is specified.
--
IF NOT @referenceDB IS NULL
BEGIN
	SET @cmd = '
	INSERT INTO #reference_set (reference_set_id, identifier)
	SELECT reference_set_id, identifier
	FROM dbo.reference_set
	'
	EXEC (@useReference + @cmd)

	SET @e = @@ERROR IF @e <> 0 BEGIN SET @errorMessage = 'Error when reading reference sets: ' + CAST(@e AS VARCHAR) RETURN -100 END
END

--
-- Read the whole gui_value table.
--
SET @cmd = '
INSERT INTO #session_setting (key_name, subkey, value_char, value_int, value_dec)
SELECT gv.key_name, gv.subkey, gv.value_char, gv.value_int, gv.value_dec
FROM dbo.gui_value gv
'
EXEC (@useSource + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN SET @errorMessage = 'Error when reading the gui_value table: ' + CAST(@e AS VARCHAR) RETURN -100 END

--
-- Store annotation types.
--
INSERT INTO #annotation_type (identifier, description)
VALUES ('gene', 'Gene name')

SET @e = @@ERROR IF @e <> 0 BEGIN SET @errorMessage = 'Error when temporarily storing annotation type: ' + CAST(@e AS VARCHAR) RETURN -100 END

INSERT INTO #annotation_type (identifier, description)
VALUES ('chromosome', 'Chromosome name')	

SET @e = @@ERROR IF @e <> 0 BEGIN SET @errorMessage = 'Error when temporarily storing annotation type: ' + CAST(@e AS VARCHAR) RETURN -100 END

------------------------------------- Insert information into target database --------------------
BEGIN TRANSACTION


SET @cmd = '
INSERT INTO kind (kind_id, name)
SELECT kind_id, name FROM #kind
'
EXEC (@useTarget + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN ROLLBACK TRANSACTION SET @errorMessage = 'Error when storing kinds: ' + CAST(@e AS VARCHAR) RETURN -100 END


SET @cmd = '
INSERT INTO wset_type (wset_type_id, name, description)
SELECT wset_type_id, name, description FROM #wset_type
'
EXEC (@useTarget + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN ROLLBACK TRANSACTION SET @errorMessage = 'Error when storing wset types: ' + CAST(@e AS VARCHAR) RETURN -100 END


SET @cmd = '
INSERT INTO status (status_id, name)
SELECT status_id, name FROM #status
'
EXEC (@useTarget + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN ROLLBACK TRANSACTION SET @errorMessage = 'Error when storing status codes: ' + CAST(@e AS VARCHAR) RETURN -100 END


SET @cmd = '
INSERT INTO sex (sex_id, name)
SELECT sex_id, name FROM #sex
'
EXEC (@useTarget + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN ROLLBACK TRANSACTION SET @errorMessage = 'Error when storing sex codes: ' + CAST(@e AS VARCHAR) RETURN -100 END


SET @cmd = '
INSERT INTO authority (authority_id, identifier, name, user_type, account_status)
SELECT authority_id, identifier, name, user_type, account_status FROM #authority
'
EXEC (@useTarget + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN ROLLBACK TRANSACTION SET @errorMessage = 'Error when storing authorities: ' + CAST(@e AS VARCHAR) RETURN -100 END


SET @cmd = '
INSERT INTO individual_type (individual_type_id, name)
SELECT individual_type_id, name FROM #individual_type
'
EXEC (@useTarget + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN ROLLBACK TRANSACTION SET @errorMessage = 'Error when storing individual types: ' + CAST(@e AS VARCHAR) RETURN -100 END


SET @cmd = '
INSERT INTO individual (individual_id, identifier, individual_type_id, sex_id, father_id, mother_id)
SELECT individual_id, identifier, individual_type_id, sex_id, father_id, mother_id FROM #individual
'
EXEC (@useTarget + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN ROLLBACK TRANSACTION SET @errorMessage = 'Error when storing control individuals: ' + CAST(@e AS VARCHAR) RETURN -100 END


SET @cmd = '
INSERT INTO sample (sample_id, identifier, individual_id)
SELECT sample_id, identifier, individual_id FROM #sample
'
EXEC (@useTarget + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN ROLLBACK TRANSACTION SET @errorMessage = 'Error when storing control samples: ' + CAST(@e AS VARCHAR) RETURN -100 END


SET @cmd = '
INSERT INTO session_setting (key_name, subkey, value_char, value_int, value_dec)
SELECT key_name, subkey, value_char, value_int, value_dec FROM #session_setting
'
EXEC (@useTarget + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN ROLLBACK TRANSACTION SET @errorMessage = 'Error when storing gui values: ' + CAST(@e AS VARCHAR) RETURN -100 END


SET @cmd = '
INSERT INTO annotation_type (identifier, description)
SELECT identifier, description FROM #annotation_type
'
EXEC (@useTarget + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN ROLLBACK TRANSACTION SET @errorMessage = 'Error when storing annotation types: ' + CAST(@e AS VARCHAR) RETURN -100 END

SET @cmd = '
INSERT INTO reference_set (reference_set_id, identifier)
SELECT reference_set_id, identifier FROM #reference_set
'
EXEC (@useTarget + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN ROLLBACK TRANSACTION SET @errorMessage = 'Error when storing reference sets: ' + CAST(@e AS VARCHAR) RETURN -100 END


COMMIT TRANSACTION

SET NOCOUNT OFF
END
