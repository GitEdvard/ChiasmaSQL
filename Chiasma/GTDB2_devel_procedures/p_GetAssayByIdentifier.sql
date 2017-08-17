USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetAssayByIdentifier]    Script Date: 11/20/2009 15:55:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_GetAssayByIdentifier]( @identifier VARCHAR (255) )

AS
BEGIN
SET NOCOUNT ON

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
