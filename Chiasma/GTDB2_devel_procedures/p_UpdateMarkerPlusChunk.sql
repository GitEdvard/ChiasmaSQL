USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdateMarkerPlusChunk]    Script Date: 11/20/2009 15:54:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_UpdateMarkerPlusChunk]

AS
BEGIN
SET NOCOUNT ON

-- #UpdateMarkerPlusTable is created in a separate call,
-- see DataServer class in client code

declare @number_rows int
create table #temp_markers(marker_id int)

select @number_rows = count(identifier) from #UpdateMarkerPlusTable 

-- Update #UpdateMarkerPlusTable with marker ids
update umpt set marker_id = m.marker_id from #UpdateMarkerPlusTable umpt inner join 
marker m on m.identifier = umpt.identifier

if @number_rows - @@ROWCOUNT <> 0
BEGIN
	RAISERROR('Failed to create/update allele variant plus, marker is missing ', 15, 1)
	RETURN			
END

-- Create allele variant plus for those markers that don't already have them
insert into allele_variant_plus
(marker_id, version, allele_variant_id, is_top_in_plus)
select marker_id, version, allele_variant_id, is_top 
	from #UpdateMarkerPlusTable 
where isnull(allele_variant_id, 0) > 0
	and not isnull(version, '###') = '###'
	and marker_id not in (select marker_id from allele_variant_plus);

-- Insert into allele_variant_plus_old_version:
--		Markers with higher version
--		Markers that have swapped strand anyway (happens sometimes in Illuminas manifests)

with asd as (
select umpt.marker_id, 
umpt.allele_variant_id as allele_variant_id_new,
avp.allele_variant_id as allele_variant_id_existing,
case isnumeric(umpt.version) when 1 then cast(umpt.version as float) else -1 end as new_version,
case isnumeric(avp.version) when 1 then cast(avp.version as float) else -1 end as existing_version,
avp.is_top_in_plus as existing_is_top_in_plus,
umpt.is_top as new_is_top_in_plus
from #UpdateMarkerPlusTable umpt 
	inner join allele_variant_plus avp on umpt.marker_id = avp.marker_id
)
insert into #temp_markers
(marker_id) 
select marker_id 
	from asd a
	inner join allele_variant av_new 
		on av_new.allele_variant_id = a.allele_variant_id_new
	inner join allele_variant av_existing 
		on av_existing.allele_variant_id = a.allele_variant_id_existing
where 
	(
		new_version > existing_version 
		or not existing_is_top_in_plus = new_is_top_in_plus
	)
	and 
	(
		av_new.variant = av_existing.variant 
		or av_new.variant = av_existing.complement
	)

insert into allele_variant_plus_old_version 
(marker_id, version, allele_variant_id, is_top_in_plus)
select avp.marker_id, version, allele_variant_id, is_top_in_plus 
from allele_variant_plus avp 
	inner join #temp_markers tm on tm.marker_id = avp.marker_id

-- Update allele variant plus extra version for those markers with 
-- at least one new allele (i.e. is not the same or complement to existing)
-- Insert the existing avp to allele variant plus extra version and add the new 
-- to allele variant plus (the new one is more likely to be used henceforth)
-- Assert that the new alleles are not already existing in 
-- allele variant plus extra version
delete from #temp_markers

insert into #temp_markers
(marker_id)
select umpt.marker_id from #UpdateMarkerPlusTable umpt 
	inner join allele_variant_plus avp on avp.marker_id = umpt.marker_id
	inner join allele_variant new_variant 
		on new_variant.allele_variant_id = umpt.allele_variant_id
	inner join allele_variant existing_variant
		on existing_variant.allele_variant_id = avp.allele_variant_id
where
(
	not existing_variant.variant = new_variant.variant
	and not existing_variant.variant = new_variant.complement
)
and umpt.marker_id not in 
(
	select avpev.marker_id 
		from allele_variant_plus_extra_version avpev
		inner join #UpdateMarkerPlusTable umpt on avpev.marker_id = umpt.marker_id
		inner join allele_variant new_variant 
			on new_variant.allele_variant_id = umpt.allele_variant_id
		inner join allele_variant avpev_variant 
			on avpev_variant.allele_variant_id = avpev.allele_variant_id
	where
		avpev_variant.variant = new_variant.variant
		or avpev_variant.variant = new_variant.complement		
)

insert into allele_variant_plus_extra_version
(marker_id, version, allele_variant_id, is_top_in_plus)
select avp.marker_id, avp.version, avp.allele_variant_id, avp.is_top_in_plus 
	from allele_variant_plus avp 
	inner join #temp_markers tm on tm.marker_id = avp.marker_id


-- Always update allele variant plus table,
-- to correct any errors from previous manifests
-- Exeption for problem markers
update avp set
	version = umpt.version,
	allele_variant_id = umpt.allele_variant_id,
	is_top_in_plus = umpt.is_top
from #UpdateMarkerPlusTable umpt
	inner join allele_variant_plus avp on avp.marker_id = umpt.marker_id
where 
	isnull(umpt.allele_variant_id, 0) > 0
	and not isnull(umpt.version, '###') = '###'
	and avp.marker_id not in
	(
		select avpev.marker_id 
		from allele_variant_plus_extra_version avpev
			inner join #UpdateMarkerplusTable umpt on umpt.marker_id = avpev.marker_id
			inner join allele_variant existing_av on existing_av.allele_variant_id = avpev.allele_variant_id
			inner join allele_variant new_av on new_av.allele_variant_id = umpt.allele_variant_id
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
	allele_variant_plus_extra_version_id int
)

insert into #swop_markers
select umpt.marker_id, avpev.allele_variant_plus_extra_version_id
	from #UpdateMarkerPlusTable umpt 
	inner join allele_variant_plus_extra_version avpev 
		on umpt.marker_id = avpev.marker_id
	inner join allele_variant avpev_variant 
		on avpev_variant.allele_variant_id = avpev.allele_variant_id
	inner join allele_variant umpt_variant on umpt_variant.allele_variant_id = umpt.allele_variant_id
where
	avpev_variant.variant = umpt_variant.variant
	or avpev_variant.variant = umpt_variant.complement

-- Delete from extra version
delete from avpev 
	from allele_variant_plus_extra_version avpev
	inner join #swop_markers sm 
		on avpev.allele_variant_plus_extra_version_id = sm.allele_variant_plus_extra_version_id

-- Insert existing allele vairants to extra version
insert into allele_variant_plus_extra_version
(marker_id, version, allele_variant_id, is_top_in_plus)
select avp.marker_id, version, allele_variant_id, is_top_in_plus 
	from allele_variant_plus avp 
	inner join #swop_markers sm on sm.marker_id = avp.marker_id

-- Update primary alleel variants with the new variants
update avp set
	version = umpt.version,
	allele_variant_id = umpt.allele_variant_id,
	is_top_in_plus = umpt.is_top
from allele_variant_plus avp 
	inner join #swop_markers sm on sm.marker_id = avp.marker_id
	inner join #UpdateMarkerPlusTable umpt on sm.marker_id = umpt.marker_id


 
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to create/update marker allele variant', 15, 1)
	RETURN
END

SET NOCOUNT OFF
END


