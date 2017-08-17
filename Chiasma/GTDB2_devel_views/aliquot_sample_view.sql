
use gtdb2_devel
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER view aliquot_sample_view as
SELECT
* 
from 
aliquot_view av left outer join
sample_prefix_view spv on
av.sample_id = spv.sample_sample_id
