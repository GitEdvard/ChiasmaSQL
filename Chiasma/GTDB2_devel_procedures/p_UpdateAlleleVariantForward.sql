USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdateAlleleVariantForward]    Script Date: 11/16/2009 13:36:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_UpdateAlleleVariantForward](
	@marker_id INTEGER,
	@version VARCHAR(10),
	@allele_variant_id TINYINT,
	@is_top_in_forward BIT)
AS
BEGIN
SET NOCOUNT ON

update avf set
	version = @version,
	allele_variant_id = @allele_variant_id,
	is_top_in_forward = @is_top_in_forward
from allele_variant_forward avf where avf.marker_id = @marker_id

IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update allele variant in forward notation: %s', 15, 1, @marker_id, @version)
	RETURN
END

SET NOCOUNT OFF
END


SET ANSI_NULLS ON
