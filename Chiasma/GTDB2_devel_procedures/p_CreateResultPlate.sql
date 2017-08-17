USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreateResultPlate]    Script Date: 11/16/2009 13:38:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_CreateResultPlate] (
	@identifier VARCHAR(255),
	@project_id INTEGER,
	@gt_method_identifier VARCHAR(255),
	@description VARCHAR(255) = NULL)

AS
BEGIN
SET NOCOUNT ON

DECLARE @gt_method_id TINYINT

SELECT @gt_method_id = gt_method_id FROM gt_method WHERE identifier = @gt_method_identifier

IF @gt_method_id IS NULL
BEGIN
	RAISERROR('gt_method_id for method %s was not found', 15, 1, @gt_method_identifier)
	RETURN
END

INSERT INTO result_plate
	(identifier,
	project_id,
	gt_method_id,
	authority_id,
	description)
VALUES
	(@identifier,
	@project_id,
	@gt_method_id,
	dbo.fGetAuthorityId(),
	@description)

SELECT 
	result_plate_id AS id,
	identifier,
	project_id,
	gt_method_id,
	uploading_flag,
	description
FROM result_plate WHERE identifier = @identifier

SET NOCOUNT OFF
END
