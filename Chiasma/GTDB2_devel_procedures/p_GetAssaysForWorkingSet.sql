USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetAssaysForWorkingSet]    Script Date: 11/20/2009 15:55:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_GetAssaysForWorkingSet](
	@id INTEGER,
	@identifier_filter VARCHAR (255) )

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
INNER JOIN wset_member ON assay.assay_id = wset_member.identifiable_id
WHERE
	wset_member.wset_id = @id AND
	assay.identifier LIKE @identifier_filter
ORDER BY assay.identifier ASC

SET NOCOUNT OFF
END
