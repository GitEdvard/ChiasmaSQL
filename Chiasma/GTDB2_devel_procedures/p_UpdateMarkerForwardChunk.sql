USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdateMarkerForwardChunk]    Script Date: 11/20/2009 15:54:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_UpdateMarkerForwardChunk]

AS
BEGIN
SET NOCOUNT ON

-- #UpdateMarkerForwardTable is created with a separate db-call
-- see DataServer class in client

declare @number_rows int
create table #temp_markers(marker_id int)

select @number_rows = count(identifier) from #UpdateMarkerForwardTable 

-- Update #UpdateMarkerForwardTable with marker ids
update umft set marker_id = m.marker_id from #UpdateMarkerForwardTable umft 
	inner join marker m on m.identifier = umft.identifier

if @number_rows - @@ROWCOUNT <> 0
BEGIN
	RAISERROR('Failed to create/update allele variant forward, marker is missing ', 15, 1)
	RETURN			
END

-- Create allele variant forward for those markers that don't already have them
insert into allele_variant_forward
(marker_id, version, allele_variant_id, is_top_in_forward)
select marker_id, forward_version, allele_variant_id_forward, is_top_in_forward 
	from #UpdateMarkerForwardTable 
where 
	isnull(allele_variant_id_forward, 0) > 0
	and not isnull(forward_version, '###') = '###'
	and	marker_id not in (select marker_id from allele_variant_forward);

-- Insert into allele_variant_forward_old_version:
--		Markers with higher version
--		Markers that have swapped strand anyway (happens sometimes in Illuminas manifests)

with asd as (
select umft.marker_id, 
umft.allele_variant_id_forward as allele_variant_id_new,
avf.allele_variant_id as allele_variant_id_existing,
case isnumeric(umft.forward_version) 
	when 1 then cast(umft.forward_version as float) 
	else -1 end 
		as new_version,
case isnumeric(avf.version) 
	when 1 then cast(avf.version as float) 
	else -1 end 
		as existing_version,
avf.is_top_in_forward as existing_is_top_in_forward,
umft.is_top_in_forward as new_is_top_in_forward
from #UpdateMarkerForwardTable umft 
	inner join allele_variant_forward avf on umft.marker_id = avf.marker_id
)
insert into #temp_markers
(marker_id) 
select a.marker_id 
	from asd a
	inner join allele_variant av_new 
		on av_new.allele_variant_id = a.allele_variant_id_new
	inner join allele_variant av_existing 
		on av_existing.allele_variant_id = a.allele_variant_id_existing
where 
	(
		new_version > existing_version 
		or not existing_is_top_in_forward = new_is_top_in_forward
	)
	and 
	(
		av_new.variant = av_existing.variant 
		or av_new.variant = av_existing.complement
	)

insert into allele_variant_forward_old_version 
(marker_id, version, allele_variant_id, is_top_in_forward)
select avf.marker_id, version, allele_variant_id, is_top_in_forward 
from allele_variant_forward avf 
	inner join #temp_markers tm on tm.marker_id = avf.marker_id

-- Update allele variant forward extra version for those markers with 
-- new alleles (i.e. is not the same or complement to existing, problem markers)
-- Insert the existing avf to allele variant forward extra version and add the new 
-- to allele variant forward (the new one is more likely to be used henceforth)
-- Assert that the new alleles are not already existing in 
-- allele variant forward extra version
delete from #temp_markers

insert into #temp_markers
(marker_id)
select umft.marker_id from #UpdateMarkerForwardTable umft 
	inner join allele_variant_forward avf on avf.marker_id = umft.marker_id
	inner join allele_variant new_variant 
		on new_variant.allele_variant_id = umft.allele_variant_id_forward
	inner join allele_variant existing_variant
		on existing_variant.allele_variant_id = avf.allele_variant_id
where
(
	not existing_variant.variant = new_variant.variant
	and not existing_variant.variant = new_variant.complement
)
and umft.marker_id not in 
(
	select avfev.marker_id 
		from allele_variant_forward_extra_version avfev
		inner join #UpdateMarkerForwardTable umft on avfev.marker_id = umft.marker_id
		inner join allele_variant new_variant 
			on new_variant.allele_variant_id = umft.allele_variant_id_forward
		inner join allele_variant avfev_variant 
			on avfev_variant.allele_variant_id = avfev.allele_variant_id
	where
		avfev_variant.variant = new_variant.variant
		or avfev_variant.variant = new_variant.complement		
)

--

insert into allele_variant_forward_extra_version
(marker_id, version, allele_variant_id, is_top_in_forward)
select avf.marker_id, avf.version, avf.allele_variant_id, avf.is_top_in_forward 
	from allele_variant_forward avf 
	inner join #temp_markers tm on tm.marker_id = avf.marker_id

-- Always update allele variant forward table,
-- to correct any errors from previous manifests
-- exception for problem markers (very few)
update avf set
	version = umft.forward_version,
	allele_variant_id = umft.allele_variant_id_forward,
	is_top_in_forward = umft.is_top_in_forward
from allele_variant_forward avf 
	inner join #UpdateMarkerForwardTable umft on avf.marker_id = umft.marker_id
where 
	isnull(umft.allele_variant_id_forward, 0) > 0
	and not isnull(umft.forward_version, '###') = '###'
	and avf.marker_id not in
	(
		select avfev.marker_id 
		from allele_variant_forward_extra_version avfev
			inner join #UpdateMarkerForwardTable umft on umft.marker_id = avfev.marker_id
			inner join allele_variant existing_av on existing_av.allele_variant_id = avfev.allele_variant_id
			inner join allele_variant new_av on new_av.allele_variant_id = umft.allele_variant_id_forward
		where 
			existing_av.variant = new_av.variant
			or existing_av.variant = new_av.complement
	) 

-- For markers that are found in the extra version table,
-- swopp extra version with primary version, and update the 
-- primary version with the new allele variant
-- (this have very little influence, except when comparing export files
-- with their checksums)
create table #swop_markers
(
	marker_id int,
	allele_variant_forward_extra_version_id int
)

insert into #swop_markers
select umft.marker_id, avfev.allele_variant_forward_extra_version_id
	from #UpdateMarkerForwardTable umft 
	inner join allele_variant_forward_extra_version avfev 
		on umft.marker_id = avfev.marker_id
	inner join allele_variant avfev_variant 
		on avfev_variant.allele_variant_id = avfev.allele_variant_id
	inner join allele_variant umft_variant on umft_variant.allele_variant_id = umft.allele_variant_id_forward
where
	avfev_variant.variant = umft_variant.variant
	or avfev_variant.variant = umft_variant.complement

-- Delete from extra version
delete from avfev 
	from allele_variant_forward_extra_version avfev
	inner join #swop_markers sm 
		on avfev.allele_variant_forward_extra_version_id = sm.allele_variant_forward_extra_version_id

-- Insert existing allele vairants to extra version
insert into allele_variant_forward_extra_version
(marker_id, version, allele_variant_id, is_top_in_forward)
select avf.marker_id, version, allele_variant_id, is_top_in_forward 
	from allele_variant_forward avf 
	inner join #swop_markers sm on sm.marker_id = avf.marker_id

-- Update primary alleel variants with the new variants
update avf set
	version = umft.forward_version,
	allele_variant_id = umft.allele_variant_id_forward,
	is_top_in_forward = umft.is_top_in_forward
from allele_variant_forward avf 
	inner join #swop_markers sm on sm.marker_id = avf.marker_id
	inner join #UpdateMarkerForwardTable umft on sm.marker_id = umft.marker_id


IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to create/update marker allele variant', 15, 1)
	RETURN
END

SET NOCOUNT OFF
END


