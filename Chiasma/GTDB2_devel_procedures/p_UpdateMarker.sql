USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdateMarker]    Script Date: 11/16/2009 13:37:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_UpdateMarker] (
	@identifier VARCHAR(255),
	@species_id INTEGER,
	@comment VARCHAR(1024) = NULL,
	@allele_variant_id_in_forward TINYINT = NULL,
	@is_top_in_forward BIT = NULL,
	@forward_version VARCHAR(10) = NULL
	)
-- Do never update the flanking sequences
-- See fDetermineTopBot and how allele results are generated for assays
-- (golden gate)
AS
BEGIN
SET NOCOUNT ON

DECLARE @markerId INTEGER

select @markerId = marker_id FROM marker WHERE identifier = @identifier

if not isnull(@allele_variant_id_in_forward, 0) = 0 
begin
	if isnull(@forward_version, '-1') = '-1'
		set @forward_version = '0'
	-- Add to allele_variant_forward or allele_variant_forward_extra_version 
	-- in case no matching allele already exists
	exec p_CreateUpdateAlleleVariantForward @marker_id = @markerId, @version = @forward_version,
			@allele_variant_id = @allele_variant_id_in_forward, 
			@is_top_in_forward = @is_top_in_forward
end

SET NOCOUNT OFF
END
