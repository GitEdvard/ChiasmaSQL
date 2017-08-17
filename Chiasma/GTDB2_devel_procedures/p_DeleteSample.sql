USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_DeleteSample]    Script Date: 11/20/2009 15:45:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_DeleteSample](@id INTEGER)

AS
BEGIN
SET NOCOUNT ON

DECLARE @sampleKindId INTEGER

SELECT @sampleKindId = kind_id FROM kind WHERE name = 'SAMPLE'
IF @sampleKindId IS NULL
BEGIN
	RAISERROR('Unable to find the kind_id for SAMPLE. Nothing deleted.', 11, 1)
	RETURN
END

--Remove the sample from any wset where it might be a member.
DELETE FROM wset_member WHERE identifiable_id = @id AND kind_id = @sampleKindId 

--Delete the actual sample.
DELETE FROM sample 
WHERE sample_id = @id


SET NOCOUNT OFF
END
