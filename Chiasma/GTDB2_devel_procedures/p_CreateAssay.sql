USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreateAssay]    Script Date: 11/16/2009 13:34:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_CreateAssay] (
	@identifier VARCHAR(255),
	@marker_id INTEGER,
	@variant CHAR(3),
	@comment VARCHAR(3000) = NULL)

AS
BEGIN
SET NOCOUNT ON

DECLARE @assay_id INTEGER
DECLARE @allele_variant_id TINYINT


SELECT @allele_variant_id = allele_variant_id
FROM allele_variant
WHERE variant = @variant

IF @allele_variant_id IS NULL
BEGIN
	RAISERROR('Unable to find the allele variant.', 15, 1)
	RETURN
END

INSERT INTO assay
	(identifier,
	marker_id,
	allele_variant_id,
	comment)
VALUES
	(@identifier,
	@marker_id,
	@allele_variant_id,
	@comment)

SELECT @assay_id = assay_id FROM assay WHERE identifier = @identifier

IF @assay_id IS NULL
BEGIN
	RAISERROR('Unable to create assay.', 15, 1)
	RETURN
END



SELECT 
	assay.assay_id AS id,
	assay.marker_id AS marker_id,
	assay.identifier AS identifier,
	allele_variant.variant AS variant,
	assay.comment AS comment
FROM assay
INNER JOIN allele_variant ON allele_variant.allele_variant_id = assay.allele_variant_id
WHERE assay.identifier = @identifier

SET NOCOUNT OFF
END
