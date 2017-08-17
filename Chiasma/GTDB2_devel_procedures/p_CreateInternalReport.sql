USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreateInternalReport]    Script Date: 11/16/2009 13:37:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_CreateInternalReport] (
	@identifier VARCHAR(255),
	@authority_id INTEGER,
	@project_id INTEGER,
	@source VARCHAR(512),
	@is_bulk BIT,
	@comment VARCHAR(512) = NULL,
	@settings XML = NULL)

AS
BEGIN
SET NOCOUNT ON

DECLARE @internal_report_id INTEGER
declare @item_unit varchar(40)

if @settings is null
begin
	RAISERROR('Unable to create internal report, settings must not be null', 15, 1)
	RETURN	
end

select @item_unit = case @is_bulk
	when 1 then
		lower(@settings.value('(//Settings/unit)[1]', 'varchar(40)'))
	else
		lower(@settings.value('(//Settings/ItemSetting)[1]', 'varchar(40)'))
	end

if @item_unit = 'subject'
begin
	set @item_unit = 'individual'
end

INSERT INTO internal_report
	(identifier,
	authority_id,
	project_id,
	source,
	is_bulk,
	comment,
	settings,
	item_unit)
VALUES
	(@identifier,
	@authority_id,
	@project_id,
	@source,
	@is_bulk,
	@comment,
	@settings,
	@item_unit)

SELECT @internal_report_id = internal_report_id FROM internal_report WHERE identifier = @identifier

IF @internal_report_id IS NULL
BEGIN
	RAISERROR('Unable to create internal report.', 15, 1)
	RETURN
END



SELECT 
	internal_report_id AS id,
	identifier,
	authority_id,
	project_id,
	source,
	is_bulk,
	uploading_flag,
	comment,
	settings,
	item_unit
FROM internal_report
WHERE identifier = @identifier

SET NOCOUNT OFF
END
