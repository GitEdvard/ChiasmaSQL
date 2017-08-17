USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdateIndividualParent]    Script Date: 11/20/2009 16:27:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_UpdateIndividualParent](
	@id INTEGER,
	@father_identifier VARCHAR(255) = NULL,
	@mother_identifier VARCHAR(255) = NULL)

AS
BEGIN
SET NOCOUNT ON

DECLARE @father_id INTEGER
DECLARE @mother_id INTEGER

-- Get father_id
IF @father_identifier IS NULL
BEGIN
	SET @father_id = NULL
END
ELSE
BEGIN
	SELECT @father_id = individual_id FROM individual WHERE identifier = @father_identifier
	IF @father_id IS NULL
	BEGIN
		RAISERROR('Father id for %s was not found', 15, 1, @father_identifier)
		RETURN
	END
END

-- Get mother_id
IF @mother_identifier IS NULL
BEGIN
	SET @mother_id = NULL
END
ELSE
BEGIN
	SELECT @mother_id = individual_id FROM individual WHERE identifier = @mother_identifier
	IF @mother_id IS NULL
	BEGIN
		RAISERROR('Mother id for %s was not found', 15, 1, @mother_identifier)
		RETURN
	END
END

-- Update individual.
UPDATE individual SET
	father_id = @father_id,
	mother_id = @mother_id
WHERE individual_id = @id
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update individual with id: %d', 15, 1, @id)
	RETURN
END

SELECT
	individual_id AS id,
	identifier,
	external_name,
	species_id,
	CONVERT( INTEGER, sex) AS sex_id,
	father_id,
	mother_id,
	individual_usage,
	comment
FROM individual
WHERE individual_id = @id

SET NOCOUNT OFF
END
