USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreateSample]    Script Date: 11/16/2009 13:39:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_CreateSample] (
	@identifier VARCHAR(255),
	@individual_id INTEGER,
	@sample_series_id INTEGER,
	@state_id SMALLINT,
	@external_name VARCHAR(255) = NULL)

AS
BEGIN
SET NOCOUNT ON

INSERT INTO sample
	(identifier,
	individual_id,
	sample_series_id,
	state_id,
	external_name)
VALUES
	(@identifier,
	@individual_id,
	@sample_series_id,
	@state_id,
	@external_name)
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to create sample with identifier: %s', 15, 1, @identifier)
	RETURN
END

SELECT * FROM sample_view
WHERE identifier = @identifier

SET NOCOUNT OFF
END
