USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreateSampleChunk]    Script Date: 11/20/2009 15:54:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_CreateSampleChunk]

AS
BEGIN
SET NOCOUNT ON

-- #CreateSampleTable is created with a separate db-call
-- see DataServer class i client


insert into sample
(identifier, external_name, 
	individual_id, sample_series_id, state_id, pos_x, pos_y, 
	volume_customer, volume_current, concentration_customer, concentration_current,
	concentration_current_device_id, comment, tube_id, plate_id)
select identifier, external_name, 
	individual_id, sample_series_id, state_id, pos_x, pos_y, 
	volume_customer, volume_current, concentration_customer, concentration_current,
	concentration_current_device_id, comment, tube_id, plate_id from #CreateSampleTable

select sv.* from sample_view sv
inner join #CreateSampleTable tcst on sv.identifier = tcst.identifier

IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to creating samples', 15, 1)
	RETURN
END

SET NOCOUNT OFF
END


