USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_ExportGenotypesGetProblemsMarkersForward]    Script Date: 11/16/2009 13:33:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_ExportGenotypesGetProblemsMarkersForward]

AS
BEGIN
SET NOCOUNT ON

-- Get markers with more than one allele_variant_forward refered to it, 
-- from the current internal report

select distinct m.marker_id 
	from marker m 
	inner join allele_variant_forward_extra_version avfev on m.marker_id = avfev.marker_id
WHERE m.identifier in 
	(SELECT name FROM #ExportGenotypesMarker)


SET NOCOUNT OFF
END


