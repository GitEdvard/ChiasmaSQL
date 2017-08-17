USE [GTDB2_devel]

-- REMAINS TO BE DONE:
-- sample series on flowcells
-- suggestion: make a new view that links sample series to plates and tubes,
-- use that view in this view  to link flow cells to sample series

-- test

GO
/****** Object:  View [dbo].[all_containers]    Script Date: 11/20/2009 13:54:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[advanced_search_view]
AS
-- aliuqot tubes
select t.tube_id as generic_container_id, t.identifier, t.status, 
		ta.volume, ta.concentration, ta.molar_concentration, s.sample_series_id, 
		ta.comment as contents_comment, t.comment as container_comment
	from tube t 
		inner join tube_aliquot ta on t.tube_id = ta.tube_id 
		inner join sample s on ta.sample_id = s.sample_id 
union
-- pooled tubes
select t.tube_id as generic_container_id, t.identifier, t.status, 
		pifa.volume, pifa.concentration, pifa.molar_concentration, s.sample_series_id, 
		pifa.comment as contents_comment, t.comment as container_comment
	from tube t 
		inner join pool_info_for_aliquots pifa on pifa.tube_id = t.tube_id 
		inner join tube_aliquot ta on ta.pool_info_for_aliquots_id = pifa.pool_info_for_aliquots_id 
		inner join sample s on ta.sample_id = s.sample_id
union
-- pooled master tubes
select t.tube_id as generic_container_id, t.identifier, t.status, 
		pifs.volume_current as volume, 
		pifs.concentration_current as concentration, pifs.molar_concentration, s.sample_series_id, 
		pifs.comment as contents_comment, t.comment as container_comment
	from tube t 
		inner join pool_info_for_samples pifs on pifs.tube_id = t.tube_id 
		inner join sample s on s.pool_info_for_samples_id = pifs.pool_info_for_samples_id 
union
-- master tubes
select t.tube_id as generic_container_id, t.identifier, t.status, 
		s.volume_current as volume, 
		s.concentration_current as concentration, s.molar_concentration, s.sample_series_id, 
		s.comment as contents_comment, t.comment as container_comment
	from tube t 
		inner join sample s on t.tube_id = s.tube_id
union
-- working plate seq
select p.plate_id AS generic_container_id, p.identifier, p.status, 
		ta.volume, ta.concentration, ta.molar_concentration, s.sample_series_id, 
		ta.comment as contents_comment, p.comment as container_comment
	from plate p 
		inner join tube_aliquot ta on ta.plate_id = p.plate_id 
		inner join sample s on ta.sample_id = s.sample_id 
union
-- pools in working plates
select p.plate_id AS generic_container_id, p.identifier, p.status, 
		pifa.volume, pifa.concentration, pifa.molar_concentration, s.sample_series_id, 
		pifa.comment as contents_comment, p.comment as container_comment
	from plate p 
		inner join pool_info_for_aliquots pifa on p.plate_id = pifa.plate_id 
		inner join tube_aliquot ta on ta.pool_info_for_aliquots_id = pifa.pool_info_for_aliquots_id 
		inner join sample s on ta.sample_id = s.sample_id
union
-- pools in master plates
select p.plate_id AS generic_container_id, p.identifier, p.status, 
		pifs.volume_current as volume, pifs.concentration_current as concentration, 
		pifs.molar_concentration, s.sample_series_id, 
		pifs.comment as contents_comment, p.comment as container_comment
	from plate p 
		inner join pool_info_for_samples pifs on p.plate_id = pifs.plate_id 
		inner join sample s on s.pool_info_for_samples_id = pifs.pool_info_for_samples_id 
union
-- master plates
select p.plate_id AS generic_container_id, p.identifier, p.status, 
		s.volume_current as volume, s.concentration_current as concentration, 
		s.molar_concentration, s.sample_series_id, 
		s.comment as contents_comment, p.comment as container_comment
	from plate p 
		inner join sample s on p.plate_id = s.plate_id
union
-- working plate geno
select p.plate_id AS generic_container_id, p.identifier, p.status, 
		a.volume, a.concentration, null, s.sample_series_id, 
		a.comment as contents_comment, p.comment as container_comment
	from plate p 
		inner join aliquot a on a.plate_id = p.plate_id 
		inner join sample s on a.sample_id = s.sample_id 
union
-- bead chips (sample series searches)
select bc.bead_chip_id AS generic_container_id, bc.identifier, bc.status, 
		s.volume_current as volume, s.concentration_current as concentration, 
		s.molar_concentration, s.sample_series_id, 
		s.comment as contents_comment, bc.comment as container_comment
	from bead_chip bc 
		inner join bead_chip_well bcw on bcw.bead_chip_id = bc.bead_chip_id 
		inner join sample s on s.sample_id = bcw.sample_id
