USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetFlowCellsForProject]    Script Date: 11/20/2009 15:58:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_GetFlowCellsForProject](@id INTEGER, @identifier_filter VARCHAR(225))

AS
BEGIN
SET NOCOUNT ON

SELECT DISTINCT
fc.flow_cell_id as id,
fc.bead_chip_type_id,
fc.identifier,
fc.comment,
fc.status,
FROM
project p
INNER JOIN sample_series_group ssg ON 
(p.project_id = ssg.identifiable_id AND ssg.sample_series_group_type = 'project')
INNER JOIN sample_series_mapping ssm ON 
(ssg.sample_series_group_id = ssm.sample_series_group_id)
INNER JOIN sample_series ss ON
(ss.sample_series_id = ssm.sample_series_id)
INNER JOIN sample s ON
(s.sample_series_id = ss.sample_series_id)
INNER JOIN individual i ON
(i.individual_id = s.individual_id)
INNER JOIN flow_cell_well fcw ON
(fcw.sample_id = s.sample_id)
INNER JOIN flow_cell fc ON
(fc.flow_cell_id = fcw.flow_cell_id)
WHERE 
p.project_id = @id AND
NOT i.individual_usage = 'SequencingControl' AND
fc.identifier LIKE @identifier_filter AND
fc.status = 'Active'

SET NOCOUNT OFF
END
