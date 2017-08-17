USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreateNegSample]    Script Date: 11/16/2009 13:37:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_CreateNegSample] (
	@identifier VARCHAR(255),
	@individual_id INTEGER,
	@sample_series_id INTEGER,
	@external_name VARCHAR(255) = NULL)

AS
BEGIN
SET NOCOUNT ON

DECLARE @state_id SMALLINT

SELECT @state_id = state_id FROM state WHERE identifier = 'Neg'

INSERT INTO sample
	(identifier,
	individual_id,
	sample_series_id,
	state_id,
	external_name)
VALUES
	(@identifier,
	@individual_id,
	@sample_series_id,
	@state_id,
	@external_name)
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to create sample with identifier: %s', 15, 1, @identifier)
	RETURN
END

SELECT * FROM sample_view
WHERE identifier = @identifier

SET NOCOUNT OFF
END


--SELECT 
--	sample_id AS id,
--	individual_id,
--	identifier,
--	sample_series_id,
--	state_id,
--	external_name,
--	container_id,
--	pos_x,
--	pos_y,
--	pos_z,
--	volume_customer,
--	concentration_customer,
--	volume_current,
--	concentration_current,
--	concentration_current_device_id,
--	comment,
--	fragment_length,
--	fragment_length_device_id,
--	molar_concentration,
--	molar_concentration_device_id,
--	is_highlighted,
--	seq_info_id
--FROM sample WHERE identifier = @identifier
