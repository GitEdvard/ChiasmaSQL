USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetAlleleVariants]    Script Date: 11/20/2009 15:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_GetAlleleVariants]

AS
BEGIN
SET NOCOUNT ON

SELECT allele_variant_id as id, variant, complement
FROM allele_variant

SET NOCOUNT OFF
END
