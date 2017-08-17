USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_BulkQCGetProblemMarkers]    Script Date: 11/16/2009 13:33:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_BulkQCGetProblemMarkers]

AS
BEGIN
SET NOCOUNT ON

-- Get markers with more than one allele_variant_forward refered to it, 
-- from the current internal report

select distinct m.marker_id 
	from marker m 
	inner join allele_variant_forward_extra_version avfev on m.marker_id = avfev.marker_id
WHERE m.identifier in 
	(SELECT name FROM #BulkQCMarker)

SET NOCOUNT OFF
END


