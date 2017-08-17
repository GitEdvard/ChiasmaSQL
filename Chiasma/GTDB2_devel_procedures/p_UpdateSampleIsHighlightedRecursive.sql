USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdateSampleIsHighlightedRecursive]    Script Date: 11/20/2009 16:29:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_UpdateSampleIsHighlightedRecursive](
	@id INTEGER,
	@is_highlighted bit
)

AS
BEGIN
SET NOCOUNT ON

declare @tube_ids table(id int)
declare @plate_ids table(id int)
declare @pifa_ids table(id int)

-- Update sample, aliquot, tube_aliquot, tube and pool_info_for_aliquots.

-- Update sample
update sample set
	is_highlighted = @is_highlighted
where sample_id = @id

-- Update aliquot
update aliquot set
	is_highlighted = @is_highlighted
	where sample_id = @id

-- Update tube_aliquot
update tube_aliquot set 
	is_highlighted = @is_highlighted 
	where sample_id = @id

insert into @tube_ids 
	select t.tube_id from tube t inner join sample s on s.tube_id = t.tube_id
	where s.sample_id = @id
	UNION
	select t.tube_id from tube_aliquot ta
	inner join tube t on ta.tube_id = t.tube_id where ta.sample_id = @id
	UNION
	select t.tube_id from tube t inner join pool_info_for_aliquots pifa on pifa.tube_id = t.tube_id
	inner join tube_aliquot ta on ta.pool_info_for_aliquots_id = pifa.pool_info_for_aliquots_id
	where ta.sample_id = @id

-- Update tube
update t set
	is_highlighted = @is_highlighted from tube t inner join @tube_ids tids on 
	t.tube_id = tids.id

insert into @plate_ids
	select p.plate_id from plate p inner join sample s on s.plate_id = p.plate_id 
	where s.sample_id = @id
	UNION
	select p.plate_id from plate p inner join aliquot a on a.plate_id = p.plate_id 
	where a.sample_id = @id
	UNION
	select p.plate_id from plate p inner join tube_aliquot ta on ta.plate_id = p.plate_id 
	where ta.sample_id = @id
	UNION
	select p.plate_id from plate p inner join pool_info_for_aliquots pifa on pifa.plate_id = 
	p.plate_id inner join tube_aliquot ta on ta.pool_info_for_aliquots_id = pifa.pool_info_for_aliquots_id
	where ta.sample_id = @id

-- Update pool_info_for_aliquots
update pifa set
	is_highlighted = @is_highlighted 
	OUTPUT inserted.pool_info_for_aliquots_id into @pifa_ids
	FROM pool_info_for_aliquots pifa inner join tube_aliquot ta on
	pifa.pool_info_for_aliquots_id = ta.pool_info_for_aliquots_id where
	ta.sample_id = @id

IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update sample with id: %d', 15, 1, @id)
	RETURN
END

-- Return tubes and plate + positions belonging to aliquots/tube_aliquots that are updated 
select * from tube_view where id in (select id from @tube_ids)

select * from plate_view where id in (select id from @plate_ids)

select * from aliquot_sample_view where sample_id = @id

select * from tube_aliquot_sample_view where sample_id = @id

select * from pool_info_for_aliquots_view where id in (select id from @pifa_ids)


SET NOCOUNT OFF
END
