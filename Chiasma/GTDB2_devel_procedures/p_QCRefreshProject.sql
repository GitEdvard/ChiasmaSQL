USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_QCRefreshProject]    Script Date: 11/20/2009 16:26:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_QCRefreshProject](@project_id INTEGER, @qcdb_name VARCHAR(255), @referencedb_name VARCHAR(255) = NULL)
AS
BEGIN

CREATE TABLE #projectMarker (markerId INTEGER NOT NULL PRIMARY KEY,
								identifier VARCHAR(255) NOT NULL,
								allele_variant CHAR(3) NULL
								)

CREATE TABLE #projectAssay (assayId INTEGER NOT NULL PRIMARY KEY,
								identifier VARCHAR(255) NOT NULL,
								markerId INTEGER NOT NULL
								)

CREATE TABLE #projectSample (sampleId INTEGER NOT NULL PRIMARY KEY,
								identifier VARCHAR(255) NOT NULL,
								individualId INTEGER NOT NULL
								)

CREATE TABLE #projectIndividual (individualId INTEGER NOT NULL PRIMARY KEY,
								identifier VARCHAR(255) NOT NULL,
								individualTypeId TINYINT NOT NULL,
								fatherId INTEGER NULL,
								motherId INTEGER NULL,
								sexId TINYINT NOT NULL
								)

CREATE TABLE #targetIndividualType (individualTypeId TINYINT NOT NULL PRIMARY KEY,
									Name VARCHAR(255) NOT NULL UNIQUE
									)

CREATE TABLE #tempParent (individualId INTEGER NOT NULL PRIMARY KEY,
								identifier VARCHAR(255) NOT NULL,
								individualTypeId INTEGER NOT NULL,
								fatherId INTEGER NULL,
								motherId INTEGER NULL,
								sexId TINYINT NOT NULL
								)								

CREATE TABLE #projectGenotype (genotypeId INTEGER NOT NULL PRIMARY KEY,
								sampleId INTEGER NOT NULL,
								individualId INTEGER NOT NULL,
								assayId INTEGER NOT NULL,
								markerId INTEGER NOT NULL,
								alleles CHAR(3) NOT NULL,
								statusId INTEGER NOT NULL,
								plateId INTEGER NOT NULL,
								posX INTEGER NULL,
								posY INTEGER NULL,
								lockedWsetId INTEGER NULL
								)
								
CREATE TABLE #projectGenotypeStatusLog (genotypeId INTEGER NOT NULL,
								oldStatusId TINYINT NOT NULL,
								newStatusId TINYINT NOT NULL,
								authorityId INTEGER NOT NULL,
								created DATETIME NOT NULL
								)
								
CREATE TABLE #projectGenotypeStatusLogTrim	(genotypeId INTEGER NOT NULL,
								oldStatusId TINYINT NOT NULL,
								newStatusId TINYINT NOT NULL,
								authorityId INTEGER NOT NULL,
								created DATETIME NOT NULL
								)							

CREATE TABLE #project (projectId INTEGER NOT NULL PRIMARY KEY,
						identifier VARCHAR(255) NOT NULL,
						comment VARCHAR(1024) NULL
						)

CREATE TABLE #wsetType (wsetTypeId INTEGER NOT NULL PRIMARY KEY,
						name VARCHAR(255) NOT NULL
						)


CREATE TABLE #projectWset (wsetId INTEGER NOT NULL PRIMARY KEY,
							identifier VARCHAR(255) NOT NULL,
							wsetTypeId INTEGER NOT NULL,
							projectId INTEGER NOT NULL,
							description VARCHAR(255) NULL,
							created DATETIME NOT NULL,
							authorityId INTEGER NOT NULL
							)

CREATE TABLE #projectWsetMember (wsetId INTEGER NOT NULL,
									kindId INTEGER NOT NULL,
									identifiableId INTEGER NOT NULL,
									PRIMARY KEY (wsetId, kindId, identifiableId)
									)
									
CREATE TABLE #projectWsetMemberTrim (wsetId INTEGER NOT NULL,
									kindId INTEGER NOT NULL,
									identifiableId INTEGER NOT NULL,
									PRIMARY KEY (wsetId, kindId, identifiableId)
									)

CREATE TABLE #projectPlate (plateId INTEGER NOT NULL PRIMARY KEY,
							identifier VARCHAR(255) NOT NULL,
							projectId INTEGER NULL,
							created DATETIME NOT NULL,
							authorityId INTEGER NOT NULL,
							description VARCHAR(255) NULL
							)

CREATE TABLE #projectPermission (projectId INTEGER NOT NULL,
								 authorityId INTEGER NOT NULL,
								 PRIMARY KEY (projectId, authorityId)
								 )	

CREATE TABLE #projectPermissionTrim (projectId INTEGER NOT NULL,
								 authorityId INTEGER NOT NULL,
								 PRIMARY KEY (projectId, authorityId)
								 )

CREATE TABLE #gene (name VARCHAR(255) NOT NULL,
					markerId INTEGER NOT NULL,
					UNIQUE (name, markerId)
					)
					
CREATE TABLE #chromosome (name VARCHAR(255) NOT NULL,
					markerId INTEGER NOT NULL,
					UNIQUE (name, markerId)
					)
					
CREATE TABLE #referenceGenotype (
	item			VARCHAR(255) NOT NULL,
	experiment		VARCHAR(255) NOT NULL,
	alleles			CHAR(3) NOT NULL,
	referenceSetId	TINYINT NOT NULL
)



DECLARE @cmd VARCHAR(2000)
DECLARE @useSource VARCHAR(24)
DECLARE @useReference VARCHAR(24)
DECLARE @useTarget VARCHAR(24)
DECLARE @e INTEGER
DECLARE @em VARCHAR(255)

SET @useSource = 'USE ' + db_name() + ' '
SET @useReference = 'USE ' + @referencedb_name + ' '
SET @useTarget = 'USE ' + @qcdb_name + ' '

SET NOCOUNT ON


--
-- Get individual type codes as stated in the target database.
--
SET @cmd = '
INSERT INTO #targetIndividualType (individualTypeId, name)
SELECT individual_type_id, name
FROM individual_type
'
EXEC (@useTarget + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN SET @em = 'Error when getting individual types from target: ' + CAST(@e AS VARCHAR) RAISERROR(@em, 15, 1) RETURN -100 END


--
-- Get the project information.
--
INSERT INTO #project (projectId, identifier, comment)
SELECT project_id, identifier, comment
FROM dbo.project
WHERE project_id = @project_id

SET @e = @@ERROR IF @e <> 0 BEGIN SET @em = 'Error when getting project information: ' + CAST(@e AS VARCHAR) RAISERROR(@em, 15, 1) RETURN -100 END

IF NOT EXISTS(SELECT * FROM #project) BEGIN SET @em = 'Could not find project with ID ' + CAST(@project_id AS VARCHAR) + ' in source database.' RAISERROR(@em, 15, 1) RETURN -100 END


--
-- Get permissions for the project.
--
SET @cmd = '
INSERT INTO #projectPermission (projectId, authorityId)
SELECT DISTINCT p.project_id, am.authority_id
FROM project p
INNER JOIN authority_group ag ON p.project_id = ag.identifiable_id
INNER JOIN authority_mapping am ON ag.authority_group_id = am.authority_group_id 
WHERE 
	ag.authority_group_type = ''Project'' AND
	p.project_id IN (SELECT projectId FROM #project)
'
EXEC (@useSource + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN SET @em = 'Error when getting project information: ' + CAST(@e AS VARCHAR) RAISERROR(@em, 15, 1) RETURN -100 END



----------------------------------------- Get data in the project -------------------------------------------

--
-- Get wset types.
--
SET @cmd = '
INSERT INTO #wsetType (wsetTypeId, name)
SELECT wset_type_id, name FROM wset_type_code
'
EXEC (@useSource + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN SET @em = 'Error when getting wset types: ' + CAST(@e AS VARCHAR) RAISERROR(@em, 15, 1) RETURN -100 END

--
-- Get the wsets which are members of the project and their types.
--
SET @cmd = '
INSERT INTO #projectWset (wsetId, identifier, wsetTypeId, projectId, description, created, authorityId)
SELECT wset_id, identifier, wset_type_id, project_id, description, created, authority_id
FROM dbo.wset
WHERE project_id IN (SELECT projectId FROM #project)
AND (NOT deleted = 1)
'
EXEC (@useSource + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN SET @em = 'Error when getting members of project: ' + CAST(@e AS VARCHAR) RAISERROR(@em, 15, 1) RETURN -100 END


--
-- Get the plates which are direct members of the project.
--
SET @cmd = '
INSERT INTO #projectPlate (plateId, identifier, projectId, created, authorityId, description)
SELECT rp.result_plate_id, rp.identifier, rp.project_id, rp.created, rp.authority_id, rp.description
FROM dbo.result_plate rp
WHERE rp.project_id IN (SELECT projectId FROM #project)
'

EXEC (@useSource + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN SET @em = 'Error when getting plates in project: ' + CAST(@e AS VARCHAR) RAISERROR(@em, 15, 1) RETURN -100 END


--
-- Add the plates which are members of wsets in the project. Sets the project_id to NULL
-- because the plate can belong to a project which is not in the target database.
--
SET @cmd = '
DECLARE @plateKindId INTEGER

SELECT @plateKindId = kind_id FROM dbo.kind WHERE name = ''RESULT_PLATE''

INSERT INTO #projectPlate (plateId, identifier, projectId, created, authorityId, description)
SELECT DISTINCT rp.result_plate_id, rp.identifier, NULL, rp.created, rp.authority_id, rp.description
FROM dbo.result_plate rp
INNER JOIN dbo.wset_member wm ON (wm.identifiable_id = rp.result_plate_id AND wm.kind_id = @plateKindId)
WHERE wm.wset_id IN (SELECT wsetId FROM #projectWset WHERE wsetTypeId IN (SELECT wsetTypeId FROM #wsetType WHERE name = ''PlateSet'' or name = ''SavedSession'' or name = ''ApprovedSession''))
AND rp.result_plate_id NOT IN (SELECT plateId FROM #projectPlate)
'

EXEC (@useSource + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN SET @em = 'Error when getting plates in wsets: ' + CAST(@e AS VARCHAR) RAISERROR(@em, 15, 1) RETURN -100 END


--
-- Get genotypes in the project (note, all referenced genotypes must belong to a plate in the project).
-- Genotype results are transformed to TOP strand reference
SET @cmd = '
INSERT INTO #projectGenotype 
(genotypeId, 
sampleId,
individualId,
assayId,
markerId,
alleles,
statusId,
plateId,
posX,
posY,
lockedWsetId)								
SELECT DISTINCT 
g.genotype_id,
g.sample_id,
smp.individual_id,
g.assay_id,
a.marker_id,
dbo.fTopPolarizeAlleleResult(g.allele_result_id, g.assay_id),
g.status_id,
g.result_plate_id,
g.pos_x,
g.pos_y,
g.locked_wset_id
FROM genotype g
INNER JOIN dbo.sample smp ON smp.sample_id = g.sample_id
INNER JOIN dbo.assay a ON a.assay_id = g.assay_id
WHERE g.result_plate_id IN (SELECT plateId FROM #projectPlate)								
'
EXEC (@useSource + @cmd)
								
SET @e = @@ERROR IF @e <> 0 BEGIN SET @em = 'Error when getting genotypes: ' + CAST(@e AS VARCHAR) RAISERROR(@em, 15, 1) RETURN -100 END


--
-- Get genotype log entries in the project
--
SET @cmd = '
INSERT INTO #projectGenotypeStatusLog (genotypeId, oldStatusId, newStatusId, authorityId, created)
SELECT gl.genotype_id, gl.old_value, gl.new_value, gl.authority_id, gl.performed
FROM genotype_log gl
WHERE gl.data_modified = ''status_id''
AND gl.genotype_id IN (SELECT genotypeId FROM #projectGenotype)

CREATE NONCLUSTERED INDEX projectGenotypeStatusLogIdx ON #projectGenotypeStatusLog(genotypeId) WITH FILLFACTOR = 100
'
EXEC (@useSource + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN SET @em = 'Error when getting status log information: ' + CAST(@e AS VARCHAR) RAISERROR(@em, 15, 1) RETURN -100 END

					
--
-- Get samples in the project.
--
SET @cmd = '
DECLARE @sampleKindId INTEGER

SELECT @sampleKindId = kind_id FROM dbo.kind WHERE name = ''SAMPLE''

INSERT INTO #projectSample (sampleId, identifier, individualId)
SELECT s.sample_id, s.identifier, s.individual_id
FROM dbo.sample s
INNER JOIN
(
( --Samples from results
SELECT DISTINCT g.sample_id
FROM dbo.genotype g
INNER JOIN #projectGenotype pg ON pg.genotypeId = g.genotype_id
)
UNION
( --Samples in wsets
SELECT DISTINCT wm.identifiable_id
FROM dbo.wset_member wm
INNER JOIN #projectWset pw ON pw.wsetId = wm.wset_id AND wm.kind_id = @sampleKindId AND pw.wsetTypeId IN (SELECT wsetTypeId FROM #wsetType WHERE name = ''SampleSet'')
) 
) ics ON ics.sample_id = s.sample_id
'
EXEC (@useSource + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN SET @em = 'Error when getting samples: ' + CAST(@e AS VARCHAR) RAISERROR(@em, 15, 1) RETURN -100 END

--
-- Get assays in the project.
--
SET @cmd = '
DECLARE @assayKindId INTEGER

SELECT @assayKindId = kind_id FROM dbo.kind WHERE name = ''ASSAY''

INSERT INTO #projectAssay (assayId, identifier, markerId)
SELECT a.assay_id, a.identifier, a.marker_id
FROM dbo.assay a
INNER JOIN
(
( --Assays from results
SELECT DISTINCT g.assay_id
FROM dbo.genotype g
INNER JOIN #projectGenotype pg ON pg.genotypeId = g.genotype_id
)
UNION
( --Assays in wsets
SELECT DISTINCT wm.identifiable_id
FROM dbo.wset_member wm
INNER JOIN #projectWset pw ON pw.wsetId = wm.wset_id AND wm.kind_id = @assayKindId AND pw.wsetTypeId IN (SELECT wsetTypeId FROM #wsetType WHERE name = ''AssaySet'')
)
) ica ON ica.assay_id = a.assay_id
'
EXEC (@useSource + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN SET @em = 'Error when getting assays: ' + CAST(@e AS VARCHAR) RAISERROR(@em, 15, 1) RETURN -100 END
 
--
-- Get individuals in the project.
--
SET @cmd = '
INSERT INTO #projectIndividual (individualId, identifier, individualTypeId, fatherId, motherId, sexId)
SELECT DISTINCT idv.individual_id, idv.identifier, idt.individualTypeId, idv.father_id, idv.mother_id, CAST(idv.sex AS TINYINT)
FROM dbo.individual idv
INNER JOIN #targetIndividualType idt ON idt.name = idv.individual_usage
INNER JOIN #projectSample ps ON ps.individualId = idv.individual_id
'
EXEC (@useSource + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN SET @em = 'Error when getting individuals: ' + CAST(@e AS VARCHAR) RAISERROR(@em, 15, 1) RETURN -100 END


--
-- Include all parents recursively.
--
SET @cmd = '
INSERT INTO #tempParent (individualId, identifier, individualTypeId, fatherId, motherId, sexId)
SELECT idv.individual_id, idv.identifier, idt.individualTypeId, idv.father_id, idv.mother_id, CAST(idv.sex AS TINYINT)
FROM dbo.individual idv
INNER JOIN #targetIndividualType idt ON idt.name = idv.individual_usage
WHERE ( idv.individual_id IN (SELECT fatherId FROM #projectIndividual) OR idv.individual_id IN (SELECT motherId FROM #projectIndividual) )
AND idv.individual_id NOT IN (SELECT individualId FROM #projectIndividual)

WHILE EXISTS(SELECT * FROM #tempParent)
BEGIN
	INSERT INTO #projectIndividual (individualId, identifier, individualTypeId, fatherId, motherId, sexId)
	SELECT tp.individualId, tp.identifier, tp.individualTypeId, tp.fatherId, tp.motherId, tp.sexId
	FROM #tempParent tp

	TRUNCATE TABLE #tempParent

	INSERT INTO #tempParent (individualId, identifier, individualTypeId, fatherId, motherId, sexId)
	SELECT idv.individual_id, idv.identifier, idt.individualTypeId, idv.father_id, idv.mother_id, CAST(idv.sex AS TINYINT)
	FROM dbo.individual idv
	INNER JOIN #targetIndividualType idt ON idt.name = idv.individual_usage
	WHERE ( idv.individual_id IN (SELECT fatherId FROM #projectIndividual) OR idv.individual_id IN (SELECT motherId FROM #projectIndividual) )
	AND idv.individual_id NOT IN (SELECT individualId FROM #projectIndividual)	
END
'
EXEC (@useSource + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN SET @em = 'Error when getting parents recursively: ' + CAST(@e AS VARCHAR) RAISERROR(@em, 15, 1) RETURN -100 END



--
-- Get markers in the project.
--
SET @cmd = '
DECLARE @markerKindId INTEGER

SELECT @markerKindId = kind_id FROM dbo.kind WHERE name = ''MARKER''

INSERT INTO #projectMarker (markerId, identifier, allele_variant)
SELECT m.marker_id, m.identifier, dbo.fTopPolarizeAlleleVariant(MAX(a.assay_id)) FROM dbo.marker m
INNER JOIN
(
( --Markers from results
SELECT DISTINCT a.marker_id
FROM dbo.assay a
INNER JOIN #projectAssay pa ON pa.assayId = a.assay_id
)
UNION
(  --Markers in wsets
SELECT DISTINCT wm.identifiable_id
FROM dbo.wset_member wm
INNER JOIN #projectWset pw ON pw.wsetId = wm.wset_id AND wm.kind_id = @markerKindId AND pw.wsetTypeId IN (SELECT wsetTypeId FROM #wsetType WHERE name = ''MarkerSet'')
)
) icm ON icm.marker_id = m.marker_id
INNER JOIN 
dbo.assay a ON (a.marker_id = m.marker_id)
GROUP BY m.marker_id, m.identifier
'
EXEC (@useSource + @cmd)

SELECT * from #projectMarker

SET @e = @@ERROR IF @e <> 0 BEGIN SET @em = 'Error when getting markers: ' + CAST(@e AS VARCHAR) RAISERROR(@em, 15, 1) RETURN -100 END


--
-- Get wset members for wsets in the project.
--
SET @cmd = '
INSERT INTO #projectWsetMember (wsetId, kindId, identifiableId)
SELECT wm.wset_id, wm.kind_id, wm.identifiable_id
FROM dbo.wset_member wm
INNER JOIN #projectWset pw ON pw.wsetId = wm.wset_id
'
EXEC (@useSource + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN SET @em = 'Error when getting wset members: ' + CAST(@e AS VARCHAR) RAISERROR(@em, 15, 1) RETURN -100 END



------------------------------------ Avoid items already in the target database ------------------------------

SET @cmd = '
DELETE FROM #projectMarker WHERE markerId IN (SELECT marker_id FROM marker)
DELETE FROM #projectAssay WHERE assayId IN (SELECT assay_id FROM assay)
DELETE FROM #projectIndividual WHERE individualId IN (SELECT individual_id FROM individual)
DELETE FROM #projectSample WHERE sampleId IN (SELECT sample_id FROM sample)
DELETE FROM #projectGenotype WHERE genotypeId IN (SELECT genotype_id FROM denorm_genotype)
DELETE FROM #projectWset WHERE wsetId IN (SELECT wset_id FROM wset)
DELETE FROM #projectPlate WHERE plateId IN (SELECT plate_id FROM plate)
DELETE FROM #project WHERE projectId IN (SELECT project_id FROM project)

INSERT INTO #projectPermissionTrim (projectId, authorityId)
SELECT pp.projectId, pp.authorityId
FROM #projectPermission pp 
LEFT OUTER JOIN permission target_pp ON (target_pp.project_id = pp.projectId AND target_pp.authority_id = pp.authorityId)
WHERE target_pp.authority_id IS NULL

INSERT INTO #projectGenotypeStatusLogTrim (genotypeId, oldStatusId, newStatusId, authorityId, created)
SELECT pgsl.genotypeId, pgsl.oldStatusId, pgsl.newStatusId, pgsl.authorityId, pgsl.created
FROM #projectGenotypeStatusLog pgsl
LEFT OUTER JOIN status_log sl ON sl.genotype_id = pgsl.genotypeId AND sl.created = pgsl.created
WHERE sl.genotype_id IS NULL

INSERT INTO #projectWsetMemberTrim (identifiableId, kindId, wsetId)
SELECT pwm.identifiableId, pwm.kindId, pwm.wsetId
FROM #projectWsetMember pwm
LEFT OUTER JOIN wset_member wm ON wm.identifiable_id = pwm.identifiableId AND wm.kind_id = pwm.kindId AND wm.wset_id = pwm.wsetId
WHERE wm.identifiable_id IS NULL 
'
EXEC (@useTarget + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN SET @em = 'Error when removing items already in the target database: ' + CAST(@e AS VARCHAR) RAISERROR(@em, 15, 1) RETURN -100 END



---------------------------------------------- Get annotations ---------------------------------------------

--
-- Get marker-gene pairs associated to the project.
--
SET @cmd = '					
INSERT INTO #gene (name, markerId)
SELECT LEFT(gene, 255), marker_id
FROM dbo.marker_details
WHERE marker_id IN (SELECT markerId FROM #projectMarker)
AND NOT gene IS NULL
'
EXEC (@useSource + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN SET @em = 'Error when getting marker-gene pairs: ' + CAST(@e AS VARCHAR) RAISERROR(@em, 15, 1) RETURN -100 END

--
-- Get marker-chromosome pairs associated to the project.
--
SET @cmd = '
INSERT INTO #chromosome (name, markerId)
SELECT chromosome, marker_id 
FROM dbo.marker_details
WHERE marker_id IN (SELECT markerId FROM #projectMarker)
AND NOT chromosome IS NULL
'
EXEC (@useSource + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN SET @em = 'Error when getting marker-chromosome pairs: ' + CAST(@e AS VARCHAR) RAISERROR(@em, 15, 1) RETURN -100 END





--
-- Get reference genotypes if a reference database is specified.
--
IF NOT @referencedb_name IS NULL
BEGIN
	SET @cmd = '
	INSERT INTO #referenceGenotype (item, experiment, alleles, referenceSetId)
	SELECT individual, marker, alleles, reference_set_id 
	FROM dbo.reference_genotype
	WHERE marker IN (SELECT identifier FROM #projectMarker)
	'
	EXEC (@useReference + @cmd)

	SET @e = @@ERROR IF @e <> 0 BEGIN SET @em = 'Error when getting reference genotypes: ' + CAST(@e AS VARCHAR) RAISERROR(@em, 15, 1) RETURN -100 END
END

------------------------------------------- Store data in the target database --------------------------------


--
-- Copy the actual project.
--
SET @cmd = '
INSERT INTO project (project_id, identifier, comment)
SELECT p.projectId, p.identifier, p.comment
FROM #project p
'
EXEC (@useTarget + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN SET @em = 'Error when storing the project: ' + CAST(@e AS VARCHAR) RAISERROR(@em, 15, 1) RETURN -100 END

--
-- Copy permissions for the project.
--
SET @cmd = '
INSERT INTO permission (project_id, authority_id)
SELECT pp.projectId, pp.authorityId
FROM #projectPermissionTrim pp
'
EXEC (@useTarget + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN SET @em = 'Error when storing permissions for the project: ' + CAST(@e AS VARCHAR) RAISERROR(@em, 15, 1) RETURN -100 END


--
-- Copy markers in the project. 
--
SET @cmd = '
INSERT INTO marker (marker_id, identifier, allele_variant)
SELECT m.markerId, m.identifier, m.allele_variant
FROM #projectMarker m
'
EXEC (@useTarget + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN SET @em = 'Error when storing markers: ' + CAST(@e AS VARCHAR) RAISERROR(@em, 15, 1) RETURN -100 END

--
-- Copy assays in the project.
--
SET @cmd = '
INSERT INTO assay (assay_id, identifier, marker_id)
SELECT a.assayId, a.identifier, a.markerId
FROM #projectAssay a
'
EXEC (@useTarget + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN SET @em = 'Error when storing assays: ' + CAST(@e AS VARCHAR) RAISERROR(@em, 15, 1) RETURN -100 END

--
-- Copy individuals in the project.
--
SET @cmd = '
INSERT INTO individual (individual_id, identifier, individual_type_id, sex_id, father_id, mother_id)
SELECT idv.individualId, idv.identifier, idv.individualTypeId, idv.sexId, idv.fatherId, idv.motherId
FROM #projectIndividual idv
'
EXEC (@useTarget + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN SET @em = 'Error when storing individuals: ' + CAST(@e AS VARCHAR) RAISERROR(@em, 15, 1) RETURN -100 END

--
-- Copy samples in the project.
--
SET @cmd = '
INSERT INTO sample (sample_id, identifier, individual_id)
SELECT s.sampleId, s.identifier, s.individualId
FROM #projectSample s
'
EXEC (@useTarget + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN SET @em = 'Error when storing samples: ' + CAST(@e AS VARCHAR) RAISERROR(@em, 15, 1) RETURN -100 END

--
-- Copy plates in the project.
--
SET @cmd = '
INSERT INTO plate (plate_id, identifier, project_id, authority_id, created, description)
SELECT pp.plateId, pp.identifier, pp.projectId, pp.authorityId, pp.created, pp.description
FROM #projectPlate pp
'
EXEC (@useTarget + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN SET @em = 'Error when storing plates: ' + CAST(@e AS VARCHAR) RAISERROR(@em, 15, 1) RETURN -100 END
 
--
-- Copy genotypes in the project.
--
SET @cmd = '
INSERT INTO denorm_genotype (
genotype_id,
sample_id,
individual_id,
assay_id,
marker_id,
alleles,
status_id,
plate_id,
pos_x,
pos_y,
locked_wset_id
)
SELECT 
pg.genotypeId,
pg.sampleId,
pg.individualId,
pg.assayId,
pg.markerId,
pg.alleles,
pg.statusId,
pg.plateId,
pg.posX,
pg.posY,
pg.lockedWsetId
FROM #projectGenotype pg
'
EXEC (@useTarget + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN SET @em = 'Error when storing genotypes: ' + CAST(@e AS VARCHAR) RAISERROR(@em, 15, 1) RETURN -100 END

--
-- Copy genotype status log entries.
--
SET @cmd = '
INSERT INTO status_log (genotype_id, old_status_id, new_status_id, authority_id, created)
SELECT pgslt.genotypeId, pgslt.oldStatusId, pgslt.newStatusId, pgslt.authorityId, pgslt.created
FROM #projectGenotypeStatusLogTrim pgslt
'
EXEC (@useTarget + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN SET @em = 'Error when storing status log entries: ' + CAST(@e AS VARCHAR) RAISERROR(@em, 15, 1) RETURN -100 END

--
-- Copy the wsets which are members of the project.
--
SET @cmd = '
INSERT INTO wset (wset_id, identifier, authority_id, wset_type_id, project_id, created, description)
SELECT pw.wsetId, pw.identifier, pw.authorityId, pw.wsetTypeId, pw.projectId, pw.created, pw.description
FROM #projectWset pw
'
EXEC (@useTarget + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN SET @em = 'Error when storing wsets: ' + CAST(@e AS VARCHAR) RAISERROR(@em, 15, 1) RETURN -100 END


--
-- Copy the wset members.
--
SET @cmd = '
INSERT INTO wset_member (identifiable_id, kind_id, wset_id)
SELECT pwm.identifiableId, pwm.kindId, pwm.wsetId
FROM #projectWsetMemberTrim pwm
'
EXEC (@useTarget + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN SET @em = 'Error when storing wset members: ' + CAST(@e AS VARCHAR) RAISERROR(@em, 15, 1) RETURN -100 END


--
-- Copy the reference genotypes.
--
SET @cmd = '
INSERT INTO reference_genotype (item, experiment, alleles, reference_set_id)
SELECT rg.item, rg.experiment, rg.alleles, rg.referenceSetId
FROM #referenceGenotype rg
'
EXEC (@useTarget + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN SET @em = 'Error when storing reference genotypes: ' + CAST(@e AS VARCHAR) RAISERROR(@em, 15, 1) RETURN -100 END



-------------------------------------- Write annotations -------------------------------------------

--
-- Write gene annotations.
--
SET @cmd = '
DECLARE @tempGene VARCHAR(255)
DECLARE @tempMarkerId INTEGER
DECLARE @geneAnnotationTypeId INTEGER

SELECT @geneAnnotationTypeId = annotation_type_id FROM annotation_type WHERE identifier = ''gene''

WHILE EXISTS(SELECT * FROM #gene)
BEGIN
	SELECT TOP 1 @tempGene = name, @tempMarkerId = markerId FROM #gene
	
	INSERT INTO annotation (annotation_type_id, value)
	VALUES (@geneAnnotationTypeId, @tempGene)
		
	INSERT INTO annotation_link (marker_id, annotation_id)
	VALUES (@tempMarkerId, SCOPE_IDENTITY())
		
	DELETE FROM #gene WHERE markerId = @tempMarkerId
END
'
EXEC (@useTarget + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN SET @em = 'Error when storing gene annotation: ' + CAST(@e AS VARCHAR) RAISERROR(@em, 15, 1) RETURN -100 END

--
-- Write chromosome annotations.
--
SET @cmd = '
DECLARE @tempChrom VARCHAR(255)
DECLARE @tempMarkerId INTEGER
DECLARE @chromAnnotationTypeId INTEGER

SELECT @chromAnnotationTypeId = annotation_type_id FROM annotation_type WHERE identifier = ''chromosome''

WHILE EXISTS(SELECT * FROM #chromosome)
BEGIN
	SELECT TOP 1 @tempChrom = name, @tempMarkerId = markerId FROM #chromosome
	
	INSERT INTO annotation (annotation_type_id, value)
	VALUES (@chromAnnotationTypeId, @tempChrom)
	
	INSERT INTO annotation_link (marker_id, annotation_id)
	VALUES (@tempMarkerId, SCOPE_IDENTITY())

	--Also insert the chromosome name directly into the marker table.
	UPDATE marker SET chrom_name = @tempChrom WHERE marker_id = @tempMarkerId
	
	DELETE FROM #chromosome WHERE markerId = @tempMarkerId
END
'
EXEC (@useTarget + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN SET @em = 'Error when storing chromosome annotation: ' + CAST(@e AS VARCHAR) RAISERROR(@em, 15, 1) RETURN -100 END



SET NOCOUNT OFF

END
