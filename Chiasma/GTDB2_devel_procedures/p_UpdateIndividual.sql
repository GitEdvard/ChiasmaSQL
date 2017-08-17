USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdateIndividual]    Script Date: 11/20/2009 16:27:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_UpdateIndividual](
	@id INTEGER,
	@identifier VARCHAR(255),
	@species_id INTEGER,
	@external_name VARCHAR(255) = NULL,
	@individual_usage VARCHAR(32),
	@sex_id INTEGER,
	@mother_id INTEGER = NULL,
	@father_id INTEGER = NULL,
	@comment VARCHAR(1024) = NULL)

AS
BEGIN
SET NOCOUNT ON

-- Update individual.
UPDATE individual SET
	identifier = @identifier,
	species_id = @species_id,
	external_name = @external_name,
	individual_usage = @individual_usage,
	sex = CONVERT(CHAR, @sex_id),
	mother_id = @mother_id,
	father_id = @father_id,
	comment = @comment
WHERE individual_id = @id
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update individual with id: %d', 15, 1, @id)
	RETURN
END

SET NOCOUNT OFF
END
