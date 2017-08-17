USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_DeleteSampleMapping]    Script Date: 11/20/2009 15:45:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_DeleteSampleMapping](
	@id INTEGER,
	@sample_id INTEGER)

AS
BEGIN
SET NOCOUNT ON

-- Delete sample to sample working set mapping.
DELETE FROM wset_member
WHERE
	wset_id = @id AND
	identifiable_id = @sample_id

SET NOCOUNT OFF
END
