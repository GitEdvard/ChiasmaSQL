USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetMarkersByIdentifierFilter]    Script Date: 11/20/2009 16:02:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_GetMarkersByIdentifierFilter]( @identifier_filter VARCHAR (255) )

AS
BEGIN
SET NOCOUNT ON

SELECT 
	marker_id AS id,
	identifier AS identifier,
	species_id AS species_id,
	comment AS comment
FROM marker
WHERE identifier LIKE @identifier_filter
ORDER BY identifier ASC

SET NOCOUNT OFF
END
