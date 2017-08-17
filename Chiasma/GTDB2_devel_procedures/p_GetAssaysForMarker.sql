USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetAssaysForMarker]    Script Date: 11/20/2009 15:55:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_GetAssaysForMarker]( @marker_id INTEGER )

AS
BEGIN
SET NOCOUNT ON

SELECT 
	assay.assay_id AS id,
	assay.identifier AS identifier,
	assay.marker_id AS marker_id,
	allele_variant.variant AS variant,
	assay.comment AS comment
FROM assay
INNER JOIN allele_variant ON allele_variant.allele_variant_id = assay.allele_variant_id
WHERE assay.marker_id = @marker_id

SET NOCOUNT OFF
END
