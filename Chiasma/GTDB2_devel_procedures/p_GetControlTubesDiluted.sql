USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetControlTubesDiluted]    Script Date: 11/20/2009 15:57:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[p_GetControlTubesDiluted](
	@individual_usage varchar(50)
)

AS
BEGIN
SET NOCOUNT ON

create table #tmp(
tube_id int
)

insert into #tmp
(tube_id)
select t.tube_id
from tube t
inner join tube_aliquot ta on ta.tube_id = t.tube_id
inner join sample s on ta.sample_id = s.sample_id
inner join individual i on s.individual_id = i.individual_id
where i.individual_usage = @individual_usage and isnull(ta.pool_info_for_aliquots_id, -1) = -1

select tv.* , tapv.*
from tube_view tv
inner join tube_aliquot_prefix_view tapv on tv.id = tapv.ta_tube_id
inner join #tmp t on t.tube_id = tv.id

select * 
from dilute_history dh 
inner join #tmp t on t.tube_id = dh.to_tube_id

SET NOCOUNT OFF
END
