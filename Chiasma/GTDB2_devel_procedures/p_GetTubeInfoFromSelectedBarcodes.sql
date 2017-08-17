USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetTubeInfoFromSelectedBarcodes]    Script Date: 11/20/2009 15:54:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_GetTubeInfoFromSelectedBarcodes]

AS
BEGIN
SET NOCOUNT ON

SELECT t.tube_id, t.method, bc.code as identifier, t.tube_usage, s.sample_id, ta.tube_aliquot_id, 
ss1.sample_series_id as sample_sample_series_id, 
ss2.sample_series_id as tube_aliquot_sample_series_id from 
tube t inner join barcode bc on t.tube_id = bc.identifiable_id and bc.kind = 'container' inner join 
#SelectedTubes st on
bc.code = st.identifier 
left outer join sample s on
t.tube_id = s.tube_id
left outer join sample_series ss1 on ss1.sample_series_id = s.sample_series_id
left outer join tube_aliquot ta on
ta.tube_id = t.tube_id left outer join sample s2 on s2.sample_id = ta.sample_id left outer join 
sample_series ss2 on ss2.sample_series_id = s2.sample_series_id

SET NOCOUNT OFF
END
