use GTDB2_devel

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create VIEW tube_sample_view AS

select *, spv.sample_sample_id as sample_id from 
	tube_view tv
	inner join sample_prefix_view spv on spv.sample_tube_id = tv.id

