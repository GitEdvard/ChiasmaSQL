USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_DeleteResultPlate]    Script Date: 11/20/2009 15:45:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_DeleteResultPlate](@result_plate_id INTEGER, @plate_owner_only BIT)

--Stores the result plate information in the history table and then deletes
--the genotypes and the result plate. If @plate_owner_only is set to 1,
--the procedure will return an error if the current user is not the
--owner of the plate which is about to be deleted.

AS 
BEGIN
SET NOCOUNT ON

DECLARE @plateAuthorityId INTEGER
DECLARE @resultPlateKindId INTEGER


--If the plate_owner_only flag is set, investigate if the current user is the plate owner.
IF @plate_owner_only = 1
BEGIN
	SELECT @plateAuthorityId = authority_id FROM result_plate WHERE result_plate_id = @result_plate_id

	IF NOT @plateAuthorityId = dbo.fGetAuthorityId()
	BEGIN
		RAISERROR('The owner of the plate is different from the current user. Nothing deleted.', 11, 1)
		RETURN
	END
END


--Make sure no genotype in the plate is locked.
IF EXISTS(SELECT * FROM genotype WHERE result_plate_id = @result_plate_id AND NOT locked_wset_id IS NULL)
BEGIN
	RAISERROR('Locked genotypes belong to the plate. Nothing deleted.', 11, 1)
	RETURN
END

SELECT @resultPlateKindId = kind_id FROM kind WHERE name = 'RESULT_PLATE'
IF @resultPlateKindId IS NULL
BEGIN
	RAISERROR('Unable to find the kind_id for RESULT_PLATE. Nothing deleted.', 11, 1)
	RETURN
END


--Delete the plate from any wset where it might be a member.
DELETE FROM wset_member WHERE identifiable_id = @result_plate_id AND kind_id = @resultPlateKindId 

--Delete genotypes belonging to the plate.
DELETE FROM genotype WHERE result_plate_id = @result_plate_id

--Delete the result plate.
DELETE FROM result_plate WHERE result_plate_id = @result_plate_id


SET NOCOUNT OFF
END
