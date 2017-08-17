USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreateAlleleVariantForward]    Script Date: 11/16/2009 13:36:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_CreateAlleleVariantForward](
	@marker_id INTEGER,
	@version VARCHAR(10),
	@allele_variant_id TINYINT,
	@is_top_in_forward BIT)
AS
BEGIN
SET NOCOUNT ON

INSERT INTO allele_variant_forward
	(marker_id,
	 version,
	 allele_variant_id,
	 is_top_in_forward)
VALUES
	(@marker_id,
	 @version,
	 @allele_variant_id,
	 @is_top_in_forward)		


IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to create allele variant in forward notation: %s', 15, 1, @marker_id, @version)
	RETURN
END

SET NOCOUNT OFF
END


SET ANSI_NULLS ON
