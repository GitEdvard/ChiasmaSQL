USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreateSampleSeriesGroup]    Script Date: 11/16/2009 13:39:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_CreateSampleSeriesGroup]
	(@identifier VARCHAR(255),
	 @identifiable_id INTEGER = NULL,
	 @sample_series_group_type VARCHAR(32))

AS
BEGIN
SET NOCOUNT ON

-- Create sample series group.
INSERT INTO sample_series_group (identifier, comment, identifiable_id, sample_series_group_type)
	VALUES (@identifier, NULL, @identifiable_id, @sample_series_group_type)
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to create sample series group with identifier: %s', 15, 1, @identifier)
	RETURN
END

SELECT 
	sample_series_group_id AS id,
	identifier,
	comment,
	identifiable_id,
	sample_series_group_type
FROM sample_series_group WHERE identifier = @identifier

SET NOCOUNT OFF
END
