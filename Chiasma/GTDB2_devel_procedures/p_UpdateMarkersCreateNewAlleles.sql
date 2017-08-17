USE [GTDB2_devel]
GO
-- Not current 


/****** Object:  StoredProcedure [dbo].[p_UpdateMarkersCreateNewAlleles]    Script Date: 11/16/2009 13:33:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_UpdateMarkersCreateNewAlleles]
-- The temp table #MarkerAllelesUpdate has to be initialized in a separated call
-- See Chiasma client code

AS
BEGIN
SET NOCOUNT ON

-- Get the marker ids
update mau set marker_id = m.marker_id from #MarkerAllelesUpdate mau inner join 
marker m on m.identifier = mau.marker_identifier 

-- Check which of the markers in temp table #MarkerAllelesUpdate have matching alleles in
-- allele_variant_forward table
update mau set update_flag = 0 from #MarkerAllelesUpdate mau inner join 
allele_variant_forward avf on 
mau.marker_id = avf.marker_id and mau.allele_variant_id = avf.allele_variant_id and 
mau.is_top_in_forward = avf.is_top_in_forward;

-- Find out which of the markers already have allele-variant-forward associated
-- for these markers, create new allele_variant forward with primary version = 0
with asd as (
select case count(avf.marker_id) when 0 then 1 else 0 end as primary_version 
from #MarkerAllelesUpdate mau left outer join allele_variant_forward avf on 
mau.marker_id = avf.marker_id)
update mau set primary_version = a.primary_version from #MarkerAllelesUpdate mau inner join 
asd a on a.marker_id = mau.marker_id

-- Create new allele_variant_forward
insert into allele_variant_forward
(marker_id, version, allele_variant_id, is_top_in_forward, primary_version)
select marker_id, version, allele_variant_id, is_top_in_forward, primary_version from 
#MarkerAllelesUpdate where update_flag = 1


SET NOCOUNT OFF
END


