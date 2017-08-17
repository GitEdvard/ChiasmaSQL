USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetMarkerHistory]    Script Date: 11/20/2009 16:02:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_GetMarkerHistory]( @id INTEGER )

AS
BEGIN
SET NOCOUNT ON

SELECT 
	marker_id AS id,
	identifier,
	species_id,
	comment, 
	marker_reference,
	fiveprime_flank,
	threeprime_flank,
	gene,
	position,
	position_reference,
	chromosome,
	changed_date,
	changed_authority_id,
	changed_action
FROM marker_history
WHERE marker_id = @id
ORDER BY changed_date ASC

SET NOCOUNT OFF
END
