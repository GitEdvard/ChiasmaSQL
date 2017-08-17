USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetGenericContainersAdvancedSearch]    Script Date: 11/20/2009 15:59:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_GetGenericContainersAdvancedSearch] (
	@identifierSearches varchar(1024) = null,
	@commentSearches varchar(1024) = null,
	@dateSearches varchar(1024) = null,
	@volumeSearches varchar(1024) = null,
	@concentrationSearches varchar(1024) = null,
	@molarConcentrationSearches varchar(1024) = null,
	@sampleSeriesIdSearches varchar(1024) = null,
	@rowTerminator varchar(20),
	@intervalTerminator varchar(20),
	@active_containers BIT)

AS
BEGIN

DECLARE @container_status VARCHAR(32)
DECLARE @select_command VARCHAR (1024)
DECLARE @identifier_like_command VARCHAR (1024)
declare @comment_like_command varchar(1024)
declare @volumeCommand varchar(1024)
declare @concentrationCommand varchar(1024)
declare @molarConcentrationCommand varchar(1024)
declare @dateCommand varchar(1024)
declare @sampleSeriesCommand varchar(1024)
DECLARE @filterTable table(filter varchar(255))
declare @intervalTable table(lowValue varchar(255), highValue varchar(255))
declare @counter int
declare @rowCount int
declare @filter varchar(255)
declare @lowValue varchar(255)
declare @highValue varchar(255)
declare @ORIdentifierLike varchar(255)
declare @ORContentsCommentLike varchar(255)
declare @ORContainerCommentLike varchar(255)
declare @OrSubQuery varchar(20)
declare @commaSubQuery varchar(20)
declare @hasIdentifierSearch bit
declare @hasCommentSearch bit
declare @hasDateSearch bit
declare @hasVolumeSearch bit
declare @hasConcentrationSearch bit
declare @hasMolarConcentrationSearch bit
declare @hasSampleSeriesSearch bit

set @ORIdentifierLike = '%'' OR asv.identifier LIKE ''%'
set @ORContentsCommentLike = '%'' OR asv.contents_comment LIKE ''%'
set @ORContainerCommentLike = '%'' OR asv.container_comment LIKE ''%'


set @OrSubQuery = ' or '
set @commaSubQuery = ', '

if isnull(@identifierSearches, '###') = '###'
	set @hasIdentifierSearch = 0
else
	set @hasIdentifierSearch = 1

if isnull(@commentSearches, '###') = '###'
	set @hasCommentSearch = 0
else
	set @hasCommentSearch = 1

if isnull(@dateSearches, '###') = '###'
	set @hasDateSearch = 0
else
	set @hasDateSearch = 1

if isnull(@volumeSearches, '###') = '###'
	set @hasVolumeSearch = 0
else
	set @hasVolumeSearch = 1

if isnull(@concentrationSearches, '###') = '###'
	set @hasConcentrationSearch = 0
else
	set @hasConcentrationSearch = 1

if isnull(@molarConcentrationSearches, '###') = '###'
	set @hasMolarConcentrationSearch = 0
else
	set @hasMolarConcentrationSearch = 1

if isnull(@sampleSeriesIdSearches, '###') = '###'
	set @hasSampleSeriesSearch = 0
else
	set @hasSampleSeriesSearch = 1


--*************************************************************
-- Identifier search
--*************************************************************
-- Build up a sub-query in the following scheme:
-- identifier like '%filter1%' or identifier like '%filterN%'
if @hasIdentifierSearch = 1
begin
	SET @identifier_like_command = 'asv.identifier LIKE ''%'
	insert into @filterTable 
	select * from fInsertTextToTable(@identifierSearches, @rowTerminator)
	select @rowCount = count(filter) from @filterTable
	set @counter = 1
	while @counter <= @rowCount
	begin 
		with asd as (select filter, row_number() over (order by filter) as rn from @filterTable)
			select @filter = filter from asd where rn = @counter
		set @identifier_like_command = @identifier_like_command + @filter + @OrIdentifierLike
		set @counter = @counter + 1
	end
	-- Fix the end of the query, subtract the last '%'' or identifier like'
	set @identifier_like_command = substring(@identifier_like_command, 1, 
		len(@identifier_like_command) - len(@OrIdentifierLike))
	set @identifier_like_command = @identifier_like_command + '%'''
end

--*************************************************************
-- Comment search
--*************************************************************
-- Build up a sub-query in the following scheme:
-- comment like '%filter1%' or comment like '%filterN%'
if @hasCommentSearch = 1
begin
	SET @comment_like_command = 'asv.contents_comment LIKE ''%'
	delete from @filterTable
	insert into @filterTable 
	select * from fInsertTextToTable(@commentSearches, @rowTerminator)
	select @rowCount = count(filter) from @filterTable
	set @counter = 1
	while @counter <= @rowCount
	begin 
		with asd as (select filter, row_number() over (order by filter) as rn from @filterTable)
			select @filter = filter from asd where rn = @counter
		set @comment_like_command = @comment_like_command + @filter + @ORContainerCommentLike +
			@filter + @ORContentsCommentLike
		set @counter = @counter + 1
	end
	-- Fix the end of the query, subtract the last '%'' or comment like'
	set @comment_like_command = substring(@comment_like_command, 1, 
		len(@comment_like_command) - len(@ORContentsCommentLike))
	set @comment_like_command = @comment_like_command + '%'''
end


--*************************************************************
-- Volume search
--*************************************************************
-- Build up a sub-query in the following scheme:
-- (volume >= x1 and volume <= x2) or (volume >= y1 and volume <= y2) or ...'
if @hasVolumeSearch = 1
begin
	delete from @intervalTable
	insert into @intervalTable
		select * from fParseIntervalsToTable(@volumeSearches, @intervalTerminator, @rowTerminator)
	select @rowCount = count(isnull(lowValue, 1)) from @intervalTable
	set @counter = 1
	set @volumeCommand = ''
	while @counter <= @rowCount
	begin
		with asd as (select lowValue, highValue, row_number() over (order by lowValue) as rn 
			from @intervalTable)
		select @lowValue = lowValue, @highValue = highValue from asd where rn = @counter
		set @volumeCommand = @volumeCommand  + '('
		if isnumeric(@lowValue) = 1
			set @volumeCommand = @volumeCommand  + 'asv.volume >=' + @lowValue
		if isnumeric(@lowValue) = 1 and isnumeric(@highValue) = 1
			set @volumeCommand = @volumeCommand  + ' and '
		if isnumeric(@highValue) = 1
			set @volumeCommand = @volumeCommand  + 'asv.volume <=' + @highValue
		set @volumeCommand = @volumeCommand  + ')' + @OrSubQuery
		set @counter = @counter  + 1
	end
	-- remove the last ' or ' from the query
	set @volumeCommand = substring(@volumeCommand, 1, len(@volumeCommand) - len(@OrSubQuery))
end

--*************************************************************
-- Concentration search
--*************************************************************
-- Build up a sub-query in the following scheme:
-- (concentration >= x1 and concentration <= x2) or (concentration >= y1 and concentration <= y2) or ...'
if @hasConcentrationSearch = 1
begin
	delete from @intervalTable
	insert into @intervalTable
		select * from fParseIntervalsToTable(@concentrationSearches, @intervalTerminator, @rowTerminator)
	select @rowCount = count(isnull(lowValue, 1)) from @intervalTable
	set @counter = 1
	set @concentrationCommand = ''
	while @counter <= @rowCount
	begin
		with asd as (select lowValue, highValue, row_number() over (order by lowValue) as rn 
			from @intervalTable)
		select @lowValue = lowValue, @highValue = highValue from asd where rn = @counter
		set @concentrationCommand = @concentrationCommand  + '('
		if isnumeric(@lowValue) = 1
			set @concentrationCommand = @concentrationCommand  + 'asv.concentration >=' + @lowValue
		if isnumeric(@lowValue) = 1 and isnumeric(@highValue) = 1
			set @concentrationCommand = @concentrationCommand  + ' and '
		if isnumeric(@highValue) = 1
			set @concentrationCommand = @concentrationCommand  + 'asv.concentration <=' + @highValue
		set @concentrationCommand = @concentrationCommand  + ')' + @OrSubQuery
		set @counter = @counter  + 1
	end
	-- remove the last ' or ' from the query
	set @concentrationCommand = substring(@concentrationCommand, 1, len(@concentrationCommand) - len(@OrSubQuery))
end

--*************************************************************
-- Molar concentration search
--*************************************************************
-- Build up a sub-query in the following scheme:
-- (molarConcentration >= x1 and molarConcentration <= x2) or 
-- (molarConcentration >= y1 and molarConcentration <= y2) or ...'
if @hasMolarConcentrationSearch = 1
begin
	delete from @intervalTable
	insert into @intervalTable
		select * from fParseIntervalsToTable(@molarConcentrationSearches, @intervalTerminator, @rowTerminator)
	select @rowCount = count(isnull(lowValue, 1)) from @intervalTable
	set @counter = 1
	set @molarConcentrationCommand = ''
	while @counter <= @rowCount
	begin
		with asd as (select lowValue, highValue, row_number() over (order by lowValue) as rn 
			from @intervalTable)
		select @lowValue = lowValue, @highValue = highValue from asd where rn = @counter
		set @molarConcentrationCommand = @molarConcentrationCommand  + '('
		if isnumeric(@lowValue) = 1
			set @molarConcentrationCommand = @molarConcentrationCommand  + 'asv.molar_concentration >=' + @lowValue
		if isnumeric(@lowValue) = 1 and isnumeric(@highValue) = 1
			set @molarConcentrationCommand = @molarConcentrationCommand  + ' and '
		if isnumeric(@highValue) = 1
			set @molarConcentrationCommand = @molarConcentrationCommand  + 'asv.molar_concentration <=' + @highValue
		set @molarConcentrationCommand = @molarConcentrationCommand  + ')' + @OrSubQuery
		set @counter = @counter  + 1
	end
	-- remove the last ' or ' from the query
	set @molarConcentrationCommand = substring(@molarConcentrationCommand, 1, len(@molarConcentrationCommand) - len(@OrSubQuery))
end

--*************************************************************
-- Date search
--*************************************************************
-- Build up a sub-query in the following scheme:
-- (created_date >= x1 and created_date <= x2) or (created_date >= y1 and created_date <= y2) or ...'
if @hasDateSearch = 1
begin
	delete from @intervalTable
	insert into @intervalTable
		select * from fParseIntervalsToTable(@dateSearches, @intervalTerminator, @rowTerminator)
	select @rowCount = count(isnull(lowValue, 1)) from @intervalTable
	set @counter = 1
	set @dateCommand = ''
	while @counter <= @rowCount
	begin
		with asd as (select lowValue, highValue, row_number() over (order by lowValue) as rn 
			from @intervalTable)
		select @lowValue = lowValue, @highValue = highValue from asd where rn = @counter
		set @dateCommand = @dateCommand  + '('
		if isdate(@lowValue) = 1 
			set @dateCommand = @dateCommand  + 'dsv.created_date >= ''' + @lowValue + ''''
		if isdate(@lowValue) = 1 and isdate(@highValue) = 1
			set @dateCommand = @dateCommand  + ' and '
		if isdate(@highValue) = 1
			set @dateCommand = @dateCommand  + 'dsv.created_date <= ''' + @highValue + ''''
		set @dateCommand = @dateCommand  + ')' + @OrSubQuery
		set @counter = @counter  + 1
	end
	-- remove the last ' or ' from the query
	set @dateCommand = substring(@dateCommand, 1, len(@dateCommand) - len(@OrSubQuery))
end


--*************************************************************
-- Sample series search
--*************************************************************
-- Build up a sub-query in the following scheme:
-- sample_series_id in (ss_1, ss_2, ss_N)
if @hasSampleSeriesSearch = 1
begin
	delete from @filterTable
	SET @sampleSeriesCommand = 'asv.sample_series_id in ('
	insert into @filterTable 
	select * from fInsertTextToTable(@sampleSeriesIdSearches, @rowTerminator)
	select @rowCount = count(filter) from @filterTable
	set @counter = 1
	while @counter <= @rowCount
	begin 
		with asd as (select filter, row_number() over (order by filter) as rn from @filterTable)
			select @filter = filter from asd where rn = @counter
		set @sampleSeriesCommand = @sampleSeriesCommand + @filter + @commaSubQuery
		set @counter = @counter + 1
	end
	-- Fix the end of the query, subtract the last ', ' 
	set @sampleSeriesCommand = substring(@sampleSeriesCommand, 1, 
		len(@sampleSeriesCommand) - len(@commaSubQuery))
	set @sampleSeriesCommand = @sampleSeriesCommand + ')'
end

IF @active_containers = 1
BEGIN
	SET @container_status = 'Active'
END
ELSE
BEGIN
	SET @container_status = 'Disposed'
END

SET @select_command = 'SELECT distinct asv.generic_container_id FROM advanced_search_view asv '
if @hasDateSearch = 1
begin
	SET @select_command = @select_command + ' inner join date_search_view dsv on ' +
		'dsv.generic_container_id = asv.generic_container_id '
end
SET @select_command = @select_command + 'WHERE asv.status = ''' + @container_status + ''''
if @hasIdentifierSearch = 1
begin
	set @select_command = @select_command + ' AND (' + @identifier_like_command + ')'
end
if @hasCommentSearch = 1
begin
	set @select_command = @select_command + ' AND (' + @comment_like_command + ')'
end
if @hasVolumeSearch = 1
begin
	set @select_command = @select_command + 'and (' + @volumeCommand + ')'
end
if @hasConcentrationSearch = 1
begin
	set @select_command = @select_command + 'and (' + @concentrationCommand + ')'
end
if @hasMolarConcentrationSearch = 1
begin
	set @select_command = @select_command + 'and (' + @molarConcentrationCommand + ')'
end
if @hasDateSearch = 1
begin
	set @select_command = @select_command + 'and (' + @dateCommand + ')'
end
if @hasSampleSeriesSearch = 1
begin
	set @select_command = @select_command + 'and (' + @sampleSeriesCommand + ')'
end

--select @select_command


EXECUTE p_GetGenericContainers @select_command

END
