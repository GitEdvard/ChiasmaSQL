--USE [GTDB2_devel]
--GO
/****** Object:  UserDefinedFunction [dbo].[fParseIntervalsToTable]    Script Date: 11/20/2009 14:10:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create FUNCTION [dbo].[fParseIntervalsToTable](@text varchar(1024), 
	@withinIntervalTerminator varchar(10),
	@pairTerminator varchar(10))
RETURNS @retTable table
(fromValue varchar(255),
toValue varchar(255))
AS
BEGIN
-- usage:
-- select * from fParseIntervalsToTable(@str, @withinIntervalTerminator, @pairTerminator)

-- startIndex and endIndex is 1 - based
declare @tempTable table(pair varchar(1024))
declare @rowCount int
declare @counter int
declare @lowerValue varchar(255)
declare @higherValue varchar(255)
declare @index int
declare @pair as varchar(1024)

-- insert intervall pairs into temp-table
-- lowerValue <sep> higherValue
insert into @tempTable
select * from fInsertTextToTable(@text, @pairTerminator)

-- Now separate the lower and higher value from each row and
-- insert into the return table
select @rowCount = count(pair) from @tempTable
set @counter = 1
while @counter <= @rowCount
begin
	with asd as (select pair, row_number() over (order by pair) as rn from @tempTable)
	select @pair = pair from asd where rn = @counter

	set @index = charindex(@withinIntervalTerminator, @pair, 1)

	set @lowerValue = substring(@pair, 1, @index - 1)
	set @higherValue = substring(@pair, @index + len(@withinIntervalTerminator), 
		len(@pair) - @index - len(@withinIntervalTerminator) + 1)
	insert into @retTable (fromValue, toValue) 
	values (@lowerValue, @higherValue)
	set @counter = @counter + 1
end

return 

END


