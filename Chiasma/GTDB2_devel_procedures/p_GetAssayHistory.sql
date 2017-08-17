USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetAssayHistory]    Script Date: 11/20/2009 15:55:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_GetAssayHistory]( @id INTEGER )

AS
BEGIN
SET NOCOUNT ON

SELECT 
	assay_history.assay_id AS id,
	assay_history.marker_id,
	assay_history.identifier,
	allele_variant.variant,
	assay_history.comment,
	assay_history.changed_date,
	assay_history.changed_authority_id,
	assay_history.changed_action 
FROM assay_history
LEFT OUTER JOIN allele_variant ON allele_variant.allele_variant_id = assay_history.allele_variant_id
WHERE assay_history.assay_id = @id
ORDER BY assay_history.changed_date ASC

SET NOCOUNT OFF
END
