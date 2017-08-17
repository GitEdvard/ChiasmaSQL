USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetMarkerDetails]    Script Date: 11/20/2009 16:02:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_GetMarkerDetails]( @marker_id INTEGER )

AS
BEGIN
SET NOCOUNT ON

SELECT
	marker.marker_id AS id,
	marker.identifier AS identifier,
	marker.species_id AS species_id,
	marker.comment AS comment, 
	marker_details.marker_reference AS marker_reference,
	marker_details.fiveprime_flank AS fiveprime_flank,
	marker_details.threeprime_flank AS threeprime_flank,
	marker_details.gene AS gene,
	marker_details.position AS position,
	marker_details.position_reference AS position_reference,
	marker_details.chromosome AS chromosome
FROM marker
INNER JOIN marker_details ON marker_details.marker_id = marker.marker_id
WHERE marker.marker_id = @marker_id

SET NOCOUNT OFF
END
