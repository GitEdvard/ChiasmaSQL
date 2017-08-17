use gtdb2_devel
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW sample_seq_info_view AS
SELECT
	* 
FROM 
sample_view sv
LEFT OUTER JOIN seq_info_prefix_view sipv ON
sv.seq_info_id = sipv.seq_info_seq_info_id
