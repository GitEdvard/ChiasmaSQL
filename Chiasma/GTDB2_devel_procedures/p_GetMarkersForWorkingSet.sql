USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetMarkersForWorkingSet]    Script Date: 11/20/2009 16:02:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_GetMarkersForWorkingSet](
	@id INTEGER,
	@identifier_filter VARCHAR (255) )

AS
BEGIN
SET NOCOUNT ON

SELECT 
	marker.marker_id AS id,
	marker.identifier AS identifier,
	marker.species_id AS species_id,
	marker.comment AS comment
FROM marker
INNER JOIN wset_member ON marker.marker_id = wset_member.identifiable_id
WHERE
	wset_member.wset_id = @id AND
	marker.identifier LIKE @identifier_filter
ORDER BY marker.identifier ASC

SET NOCOUNT OFF
END
