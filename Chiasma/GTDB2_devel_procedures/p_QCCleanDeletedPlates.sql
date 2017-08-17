USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_QCCleanDeletedPlates]    Script Date: 11/20/2009 16:25:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_QCCleanDeletedPlates](@qcdb_name VARCHAR(255))
AS
BEGIN


CREATE TABLE #allPlates (plateId INTEGER NOT NULL PRIMARY KEY)

CREATE TABLE #deletedPlates (plateId INTEGER NOT NULL PRIMARY KEY)

DECLARE @cmd VARCHAR(2000)
DECLARE @useTarget VARCHAR(24)
DECLARE @e INTEGER
DECLARE @em VARCHAR(255)

SET @useTarget = 'USE ' + @qcdb_name + ' '


SET NOCOUNT ON

INSERT INTO #allPlates (plateId)
SELECT result_plate_id FROM result_plate

SET @e = @@ERROR IF @e <> 0 BEGIN SET @em = 'Error when getting all result plates: ' + CAST(@e AS VARCHAR) RAISERROR(@em, 15, 1) RETURN -100 END


--
-- Remove plates in target database.
--
SET @cmd = '
DECLARE @deletedGenotypes TABLE(genotypeId INTEGER NOT NULL PRIMARY KEY)

INSERT INTO #deletedPlates (plateId)
SELECT plate_id FROM plate WHERE plate_id NOT IN (SELECT plateId FROM #allPlates) 

INSERT INTO @deletedGenotypes (genotypeId)
SELECT genotype_id FROM denorm_genotype WHERE plate_id IN (SELECT plateId FROM #deletedPlates)

DELETE FROM status_log WHERE genotype_id IN (SELECT genotypeId FROM @deletedGenotypes)

DELETE FROM denorm_genotype WHERE genotype_id IN (SELECT genotypeId FROM @deletedGenotypes)

DELETE FROM plate WHERE plate_id IN (SELECT plateId FROM #deletedPlates)
'
EXEC (@useTarget + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN SET @em = 'Error when removing deleted plates from target database: ' + CAST(@e AS VARCHAR) RAISERROR(@em, 15, 1) RETURN -100 END


SET NOCOUNT OFF

END
