USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreateSampleMapping]    Script Date: 11/16/2009 13:39:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_CreateSampleMapping](
	@id INTEGER,
	@sample_id INTEGER)

AS
BEGIN
SET NOCOUNT ON

DECLARE @kind_id INTEGER

-- Get kind_id for Sample type
SELECT @kind_id = kind_id FROM kind WHERE name = 'SAMPLE'
IF @kind_id IS NULL
BEGIN
	RAISERROR('kind_id for type SAMPLE was not found', 15, 1)
	RETURN
END

-- Create mapping between sample and sample working set
INSERT INTO wset_member (identifiable_id, kind_id, wset_id) VALUES (@sample_id, @kind_id, @id)
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to create sample mapping for sample working set: %d', 15, 1, @id)
	RETURN
END

SET NOCOUNT OFF
END
