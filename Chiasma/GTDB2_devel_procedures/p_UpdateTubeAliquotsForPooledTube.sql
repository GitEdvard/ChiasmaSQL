USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdateTubeAliquotsForPooledTube]    Script Date: 11/20/2009 16:26:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[p_UpdateTubeAliquotsForPooledTube](
	@tube_id INTEGER,
	@update_state BIT,
	@state_id VARCHAR(30) = NULL,
	@update_fragment_length BIT,	
	@fragment_length VARCHAR(30) = NULL,
	@update_fragment_length_device BIT,
	@fragment_length_device_id VARCHAR(30) = NULL,
	@update_seq_state BIT,
	@seq_state_category_id VARCHAR(30) = NULL,
	@update_seq_type BIT,
	@seq_type_category_id VARCHAR(30) = NULL,
	@update_seq_application BIT,
	@seq_application_category_id VARCHAR(30) = NULL,
	@update_concentration_device bit,
	@concentration_device_id varchar(30) = null,
	@update_molar_concentration_device bit,
	@molar_concentration_device_id varchar(30) = null
)

AS
BEGIN
SET NOCOUNT ON

declare @cmd varchar(1024)

--if @update_fragment_length = 1 and isnull(@fragment_length, 'null') = 'null'

if 	@update_fragment_length = 0 and @update_fragment_length_device = 0 and
	@update_seq_state = 0 and @update_seq_type =  0 and
	@update_seq_application = 0 and @update_state = 0 and @update_concentration_device = 0 and
	@update_molar_concentration_device = 0
return


set @cmd = 'update tube_aliquot set '
if @update_fragment_length = 1
	set @cmd = @cmd + 'fragment_length = ' + ISNULL(@fragment_length, 'NULL') + ','
if @update_fragment_length_device = 1
	set @cmd = @cmd + 'fragment_length_device_id = ' + ISNULL(@fragment_length_device_id, 'NULL') + ','
if @update_seq_state = 1
	set @cmd = @cmd + 'seq_state_category_id = ' + ISNULL(@seq_state_category_id, 'NULL') + ','
if @update_seq_type = 1
	set @cmd = @cmd + 'seq_type_category_id = ' + ISNULL(@seq_type_category_id, 'NULL') + ','
if @update_seq_application = 1
	set @cmd = @cmd + 'seq_application_category_id = ' + ISNULL(@seq_application_category_id, 'NULL') + ','
if @update_state = 1
	set @cmd = @cmd + 'state_id = ' + ISNULL(@state_id, 'NULL') + ','
if @update_concentration_device = 1
	set @cmd = @cmd + 'concentration_device_id = ' + isnull(@concentration_device_id, 'null') + ','
if @update_molar_concentration_device = 1
	set @cmd = @cmd + 'molar_concentration_device_id = ' + isnull(@molar_concentration_device_id, 'null') + ','
-- Remove the last comma
set @cmd = substring(@cmd, 1, len(@cmd) - 1)
set @cmd = @cmd + ' where tube_id = ' + cast(@tube_id as varchar(30))

--SELECT @cmd

exec(@cmd)
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update tube_aliquots for tube with id: %d', 15, 1, @tube_id)
	RETURN
END

SET NOCOUNT OFF
END
