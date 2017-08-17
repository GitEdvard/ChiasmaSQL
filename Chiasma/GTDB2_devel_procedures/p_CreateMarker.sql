USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreateMarker]    Script Date: 11/16/2009 13:37:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_CreateMarker] (
	@identifier VARCHAR(255),
	@species_id INTEGER,
	@comment VARCHAR(1024) = NULL,
	@marker_reference VARCHAR(255) = NULL,
	@fiveprime_flank VARCHAR(1000) = NULL,
	@threeprime_flank VARCHAR(1000) = NULL,
	@gene VARCHAR(1000) = NULL,
	@position INTEGER = NULL,
	@position_reference VARCHAR(255) = NULL,
	@chromosome VARCHAR(30) = NULL,
	@allele_variant_id_in_forward TINYINT = NULL,
	@is_top_in_forward BIT = NULL,
	@forward_version VARCHAR(10) = NULL
	)

AS
BEGIN
SET NOCOUNT ON

DECLARE @newMarkerId INTEGER


-- Insert basic information into the marker table.
INSERT INTO marker
	(identifier,
	species_id,
	comment)
VALUES
	(@identifier,
	@species_id,
	@comment)

-- Get the ID of the newly created marker.
SELECT @newMarkerId = marker_id FROM marker WHERE identifier = @identifier

-- Insert the details into the marker_details table.
INSERT INTO marker_details
	(marker_id,
	marker_reference,
	fiveprime_flank,
	threeprime_flank,
	gene,
	position,
	position_reference,
	chromosome)
VALUES
	(@newMarkerId,
	@marker_reference,
	@fiveprime_flank,
	@threeprime_flank,
	@gene,
	@position,
	@position_reference,
	@chromosome)

if not isnull(@allele_variant_id_in_forward, 0) = 0 and not isnull(@forward_version, '-1') = '-1'
begin
	exec p_CreateAlleleVariantForward @marker_id = @newMarkerId, 
				@allele_variant_id = @allele_variant_id_in_forward,
				@version = @forward_version, @is_top_in_forward = @is_top_in_forward
end


-- Read the basic marker information.
SELECT 
	marker_id AS id,
	identifier,
	species_id AS species_id,
	comment AS comment
FROM marker
WHERE identifier = @identifier

SET NOCOUNT OFF
END
