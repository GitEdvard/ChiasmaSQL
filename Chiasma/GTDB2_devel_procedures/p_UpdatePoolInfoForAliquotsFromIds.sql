USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdatePoolInfoForAliquotsFromIds]    Script Date: 11/20/2009 16:26:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[p_UpdatePoolInfoForAliquotsFromIds](
	@ids VARCHAR(1024),
	@update_fragment_length BIT,	
	@fragment_length VARCHAR(30) = NULL,
	@update_fragment_length_device BIT,
	@fragment_length_device_id VARCHAR(30) = NULL,
	@update_molar_concentration BIT,
	@molar_concentration VARCHAR(50) = NULL,
	@update_molar_concentration_device BIT,
	@molar_concentration_device_id VARCHAR(30) = NULL,
	@update_seq_state BIT,
	@seq_state_category_id VARCHAR(30) = NULL,
	@update_seq_type BIT,
	@seq_type_category_id VARCHAR(30) = NULL,
	@update_seq_application BIT,
	@seq_application_category_id VARCHAR(30) = NULL,
	@update_concentration BIT,
	@concentration VARCHAR(50) = NULL,
	@update_concentration_device BIT,
	@concentration_device_id VARCHAR(30) = NULL,
	@update_comment BIT,
	@comment VARCHAR(1024) = NULL,
	@update_state BIT,
	@state_id VARCHAR(30) = NULL,
	@update_volume bit,
	@volume varchar(50) = null)

AS
BEGIN
SET NOCOUNT ON

declare @cmd varchar(2048)

if 	@update_fragment_length = 0 and @update_fragment_length_device = 0 and
	@update_molar_concentration = 0 and @update_molar_concentration_device =  0 and
	@update_seq_state = 0 and @update_seq_type =  0 and
	@update_seq_application = 0 and	@update_concentration = 0 and
	@update_comment = 0 AND @update_concentration_device = 0 and
	@update_state = 0 and @update_volume = 0
return


set @cmd = 'update pool_info_for_aliquots set '
if @update_fragment_length = 1
	set @cmd = @cmd + 'fragment_length = ' + ISNULL(@fragment_length, 'NULL') + ','
if @update_fragment_length_device = 1
	set @cmd = @cmd + 'fragment_length_device_id = ' + ISNULL(@fragment_length_device_id, 'NULL') + ','
if @update_molar_concentration = 1
	set @cmd = @cmd + 'molar_concentration = ' + ISNULL(@molar_concentration, 'NULL') + ','
if @update_molar_concentration_device = 1
	set @cmd = @cmd + 'molar_concentration_device_id = ' + ISNULL(@molar_concentration_device_id, 'NULL') + ','
if @update_seq_state = 1
	set @cmd = @cmd + 'seq_state_category_id = ' + ISNULL(@seq_state_category_id, 'NULL') + ','
if @update_seq_type = 1
	set @cmd = @cmd + 'seq_type_category_id = ' + ISNULL(@seq_type_category_id, 'NULL') + ','
if @update_seq_application = 1
	set @cmd = @cmd + 'seq_application_category_id = ' + ISNULL(@seq_application_category_id, 'NULL') + ','
if @update_concentration = 1
	set @cmd = @cmd + 'concentration = ' + ISNULL(@concentration, 'NULL') + ','
if @update_concentration_device = 1
	set @cmd = @cmd + 'concentration_device_id = ' + isnull(@concentration_device_id, 'null') + ','
if @update_comment = 1
	set @cmd = @cmd + 'comment = ''' + isnull(@comment, 'null') + ''','
if @update_state = 1
	set @cmd = @cmd + 'state_id = ' + isnull(@state_id, 'null') + ','
if @update_volume = 1
	set @cmd = @cmd + 'volume = ' + isnull(@volume, 'null') + ','
-- Remove the last comma
set @cmd = substring(@cmd, 1, len(@cmd) - 1)
set @cmd = @cmd + ' where pool_info_for_aliquots_id in (' + @ids + ')'

--SELECT @cmd

exec(@cmd)
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update pool_info_for_aliquots with ids: %d', 15, 1, @ids)
	RETURN
END

-- If volume is updated, updated volume for individual aliquots as well
if @update_volume = 1
begin

set @cmd = 'update ta set volume = ' + @volume + 
	'from tube_aliquot ta where ta.pool_info_for_aliquots_id in (' + @ids + ')'
exec(@cmd)

IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update tube aliquots belonging to pool_info_for_aliquots with ids: %d', 15, 1, @ids)
	RETURN
END
	
end


SET NOCOUNT OFF
END
