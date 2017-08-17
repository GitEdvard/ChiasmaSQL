USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreateBlankIndividual]    Script Date: 11/16/2009 13:34:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[p_CreateBlankIndividual] 
	-- Add the parameters for the stored procedure here
	@identifier varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--SELECT i.identifier, i.individual_id, t.*, s.* 
DECLARE @species_id INT
DECLARE @sex INT

SELECT TOP(1) @sex = sc.sex FROM sex_code sc WHERE sc.name = 'not applicable'
SELECT TOP(1) @species_id = s.species_id FROM species s WHERE s.identifier = 'not applicable'

INSERT INTO individual
(identifier,
 species_id,
 sex,
 individual_usage)
VALUES
(@identifier,
 @species_id,
 @sex,
 'BlankControl')

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
FROM individual WHERE
individual_id = SCOPE_IDENTITY()

IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to create individual with name: %s', 15, 1, @identifier)
	RETURN
END

END

