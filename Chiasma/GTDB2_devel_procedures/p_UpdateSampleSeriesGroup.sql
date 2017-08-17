USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdateSampleSeriesGroup]    Script Date: 11/20/2009 16:30:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_UpdateSampleSeriesGroup](
	@id INTEGER,
	@identifier VARCHAR(255),
	@comment VARCHAR(1024) = NULL)

AS
BEGIN
SET NOCOUNT ON

-- Update sample series group.
UPDATE sample_series_group SET
	identifier = @identifier,
	comment = @comment
WHERE sample_series_group_id = @id
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update sample series group with id: %d', 15, 1, @id)
	RETURN
END

SET NOCOUNT OFF
END
