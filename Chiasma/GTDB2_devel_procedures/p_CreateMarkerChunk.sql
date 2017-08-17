USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreateMarkerChunk]    Script Date: 11/20/2009 15:54:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_CreateMarkerChunk]

AS
BEGIN
SET NOCOUNT ON

-- #CreateMarkerTable is created with a separate db-call
-- see DataServer class i client

-- Create markers from #CreateMarkerTable
insert into marker
(identifier, species_id, comment)
select identifier, species_id, comment from #CreateMarkerTable

-- Update #CreateMarkerTable with marker_id
update cmt set marker_id = m.marker_id from #CreateMarkerTable cmt inner join
marker m on m.identifier = cmt.identifier

-- Create marker details from #CreateMarkerTable
insert into marker_details
(marker_id, marker_reference, fiveprime_flank, threeprime_flank, gene,
position, position_reference, chromosome)
select marker_id, marker_reference, fiveprime_flank, threeprime_flank, gene,
position, position_reference, chromosome from #CreateMarkerTable

-- Create allele variant forward
insert into allele_variant_forward 
(marker_id, version, allele_variant_id, is_top_in_forward)
select marker_id, isnull(forward_version, '0'), allele_variant_id_forward, is_top_in_forward 
	from #CreateMarkerTable where isnull(allele_variant_id_forward, 0) > 0

IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to create markers', 15, 1)
	RETURN
END

SET NOCOUNT OFF
END


