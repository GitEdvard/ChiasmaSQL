USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreateSpecies]    Script Date: 11/16/2009 13:39:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_CreateSpecies] (@identifier VARCHAR(255))

AS
BEGIN
SET NOCOUNT ON

-- Create species.
INSERT INTO species (identifier) VALUES (@identifier)
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to create species with identifier: %s', 15, 1, @identifier)
	RETURN
END

SELECT 
	species_id AS id,
	identifier
	FROM species WHERE identifier = @identifier
SET NOCOUNT OFF

END
