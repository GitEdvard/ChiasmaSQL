USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetMarkerById]    Script Date: 11/20/2009 16:01:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_GetMarkerById]( @id INTEGER )

AS
BEGIN
SET NOCOUNT ON

SELECT 
	marker_id AS id,
	identifier,
	species_id AS species_id,
	comment AS comment
FROM marker
WHERE marker_id = @id

SET NOCOUNT OFF
END
