USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreateResultPlateMapping]    Script Date: 11/16/2009 13:39:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_CreateResultPlateMapping](
	@id INTEGER,
	@result_plate_id INTEGER)

AS
BEGIN
SET NOCOUNT ON

DECLARE @kind_id INTEGER

-- Get kind_id for result plate type
SELECT @kind_id = kind_id FROM kind WHERE name = 'RESULT_PLATE'
IF @kind_id IS NULL
BEGIN
	RAISERROR('kind_id for type RESULT_PLATE was not found', 15, 1)
	RETURN
END

-- Create mapping between result plate and result plate working set
INSERT INTO wset_member (identifiable_id, kind_id, wset_id) VALUES (@result_plate_id, @kind_id, @id)
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to create result plate mapping for result plate working set: %d', 15, 1, @id)
	RETURN
END

SET NOCOUNT OFF
END
