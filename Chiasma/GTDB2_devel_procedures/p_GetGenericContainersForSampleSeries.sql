USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetGenericContainersForSampleSeries]    Script Date: 11/20/2009 15:59:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_GetGenericContainersForSampleSeries] (@sample_series_id INTEGER)

AS
BEGIN

create table #samples (sample_id int)
create table #plates (plate_id int, 
	pos_x int,
	pos_y int)
create table #tubes (tube_id int)

insert into #samples
SELECT sample_id FROM sample
WHERE sample_series_id = @sample_series_id 

insert into #plates
SELECT plate_id, position_x, position_y FROM aliquot a inner join #samples s on 
a.sample_id = s.sample_id
UNION
SELECT plate_id, position_x, position_y from tube_aliquot ta inner join #samples s on 
ta.sample_id = s.sample_id
union 
SELECT p.plate_id, s1.pos_x, s1.pos_y FROM plate p inner join sample s1 
on p.plate_id = s1.plate_id
inner join #samples s on s1.sample_id = s.sample_id

insert into #tubes
SELECT tube_id from tube_aliquot ta inner join #samples s on 
ta.sample_id = s.sample_id
union
SELECT t.tube_id FROM tube t inner join sample s1 
on t.tube_id = s1.tube_id
inner join #samples s on s1.sample_id = s.sample_id


DECLARE @select_command VARCHAR (1024)

SET @select_command = 'SELECT generic_container_id FROM all_containers
					WHERE generic_container_id IN (
					SELECT plate_id FROM #plates
					UNION
					SELECT tube_id from #tubes
					UNION
					SELECT bead_chip_id FROM bead_chip_well bcw inner join #samples s on 
					bcw.sample_id = s.sample_id
					UNION
					SELECT flow_cell_id FROM flow_cell_well fcw inner join #plates p on
					fcw.source_container_id = p.plate_id and 
					fcw.source_container_position_x = p.pos_x and
					fcw.source_container_position_y = p.pos_y
					UNION	
					SELECT flow_cell_id FROM flow_cell_well fcw inner join #tubes t on
					fcw.source_container_id = t.tube_id
				)
				AND status = ''Active'''


--SET @select_command = 'SELECT generic_container_id FROM all_containers
--					WHERE generic_container_id IN (
--					SELECT plate_id FROM aliquot
--					WHERE sample_id IN 
--					(
--						SELECT sample_id FROM sample
--						WHERE sample_series_id = ' + CAST(@sample_series_id AS VARCHAR(32)) + '
--					)
--
--					UNION
--					SELECT plate_id from tube_aliquot WHERE sample_id IN
--					(
--						SELECT sample_id FROM sample
--						WHERE sample_series_id = ' + CAST(@sample_series_id AS VARCHAR(32)) + '
--					)
--
--					UNION
--					SELECT tube_id from tube_aliquot WHERE sample_id IN
--					(
--						SELECT sample_id FROM sample
--						WHERE sample_series_id = ' + CAST(@sample_series_id AS VARCHAR(32)) + '
--					)
--					UNION
--					SELECT bead_chip_id FROM bead_chip_well WHERE sample_id IN
--					(
--						SELECT sample_id FROM sample
--						WHERE sample_series_id = ' + CAST(@sample_series_id AS VARCHAR(32)) + '
--					)
--					UNION
--
--					SELECT container_id FROM sample
--					WHERE sample_id IN 
--					(
--						SELECT sample_id FROM sample
--						WHERE sample_series_id = ' + CAST(@sample_series_id AS VARCHAR(32)) + '
--					)
--				)
--				AND status = ''Active'''

EXECUTE p_GetGenericContainers @select_command

END
