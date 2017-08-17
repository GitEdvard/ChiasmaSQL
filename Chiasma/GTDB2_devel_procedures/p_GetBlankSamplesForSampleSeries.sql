USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetBlankSamplesForSampleSeries]    Script Date: 11/20/2009 15:56:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
-- 7/5 2009, ändrar så att den bara hanterar rör
ALTER PROCEDURE [dbo].[p_GetBlankSamplesForSampleSeries] 
	-- Add the parameters for the stored procedure here
	@sample_series_identifier varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--SELECT i.identifier, i.individual_id, t.*, s.* 

SELECT sv.* 
FROM
sample_series ss INNER JOIN
sample_view sv ON
(sv.sample_series_id = ss.sample_series_id)
INNER JOIN 
individual i ON
(sv.individual_id = i.individual_id) 
INNER JOIN state st ON
(sv.state_id = st.state_id) WHERE
ss.identifier = @sample_series_identifier AND
st.identifier = 'Neg' AND
i.individual_usage = 'blankcontrol'

END

--SELECT
--	s.sample_id AS sample_id,
--	s.individual_id AS sample_individual_id,
--	s.identifier AS sample_identifier,
--	s.sample_series_id AS sample_sample_series_id,
--	s.state_id AS sample_state_id,
--	s.external_name AS sample_external_name,
--	s.container_id AS sample_container_id,
--	s.pos_x AS sample_pos_x,
--	s.pos_y AS sample_pos_y,
--	s.pos_z AS sample_pos_z,
--	s.volume_customer AS sample_volume_customer,
--	s.concentration_customer AS sample_concentration_customer,
--	s.volume_current AS sample_volume_current,
--	s.concentration_current AS sample_concentration_current,
--	s.concentration_current_device_id AS sample_concentration_current_device_id,
--	s.comment AS sample_comment,
--	s.fragment_length AS sample_fragment_length,
--	s.molar_concentration AS sample_molar_concentration,
--	s.is_highlighted AS sample_is_highlighted,
--	s.seq_info_id	
--FROM
--sample_series ss INNER JOIN
--sample s ON
--(s.sample_series_id = ss.sample_series_id)
--INNER JOIN 
--individual i ON
--(s.individual_id = i.individual_id) 
--INNER JOIN state st ON
--(s.state_id = st.state_id) WHERE
--ss.identifier = @sample_series_identifier AND
--st.identifier = 'Neg' AND
--i.individual_usage = 'blankcontrol'
