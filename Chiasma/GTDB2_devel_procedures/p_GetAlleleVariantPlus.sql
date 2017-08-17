USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetAlleleVariantPlus]    Script Date: 11/16/2009 13:36:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_GetAlleleVariantPlus](
	@marker_id INTEGER)
AS
BEGIN
SET NOCOUNT ON

SELECT 
	allele_variant_id,
	is_top_in_plus,
	version,
	marker_id
FROM
	allele_variant_plus
WHERE
	marker_id = @marker_id 

SET NOCOUNT OFF
END


SET ANSI_NULLS ON
