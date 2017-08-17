--USE [GTDB2_devel]
--GO
/****** Object:  UserDefinedFunction [dbo].[fGetYY]    Script Date: 11/20/2009 14:10:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create FUNCTION [dbo].[fInsertTextToTable](@text varchar(1024), 
	@rowterminator varchar(10))
RETURNS @retTable table
(name varchar(1024))
AS
BEGIN
-- usage:
-- select * from fInsertTextToTable(@str, @rowTerminator)

-- startIndex and endIndex is 1 - based
declare @endIndex bigint
declare @startIndex bigint
declare @str as varchar(1024)
declare @isterminatorFound bit
set @startIndex = 1
set @endIndex = 1
set @isTerminatorFound = 1
while @isTerminatorFound > 0
begin
	set @endIndex = charindex(@rowterminator, @text, @startIndex)
	if @endIndex = 0 
	begin
		set @isTerminatorFound = 0
		set @endIndex = len(@text) + 1
	end
	set @str = substring(@text, @startIndex, @endIndex - @startIndex)
	set @startIndex = @endIndex + len(@rowterminator)
	insert into @retTable select @str
end

return 

END


