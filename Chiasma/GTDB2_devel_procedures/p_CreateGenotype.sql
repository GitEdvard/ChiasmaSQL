USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreateGenotype]    Script Date: 11/16/2009 13:36:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Test1
--Test2

CREATE PROCEDURE [dbo].[p_CreateGenotype] (
	@result_plate_id INTEGER,
	@sample_id INTEGER,
	@assay_id INTEGER,
	@status_id TINYINT,
	@allele_result_id TINYINT,
	@pos_x TINYINT = NULL,
	@pos_y TINYINT = NULL)

AS
BEGIN
SET NOCOUNT ON


INSERT INTO genotype
	(result_plate_id,
	sample_id,
	assay_id,
	status_id,
	allele_result_id,
	pos_x,
	pos_y)
VALUES
	(@result_plate_id,
	@sample_id,
	@assay_id,
	@status_id,
	@allele_result_id,
	@pos_x,
	@pos_y)

SET NOCOUNT OFF
END
