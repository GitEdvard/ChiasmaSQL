USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreateIndividual]    Script Date: 11/16/2009 13:37:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_CreateIndividual] (
	@identifier VARCHAR(255),
	@external_name VARCHAR(255) = NULL,
	@species_id INTEGER,
	@sex_id INTEGER)

AS
BEGIN
SET NOCOUNT ON

INSERT INTO individual
	(identifier,
	 external_name,
	 species_id,
	 sex)
VALUES
	(@identifier,
	 @external_name,
	 @species_id,
	 CONVERT(CHAR, @sex_id))
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to create individual with identifier: %s', 15, 1, @identifier)
	RETURN
END

SELECT
	individual_id AS id,
	identifier,
	external_name,
	species_id,
	CONVERT(INTEGER, sex) AS sex_id,
	father_id,
	mother_id,
	individual_usage,
	comment
FROM individual
WHERE identifier = @identifier

SET NOCOUNT ON
END
