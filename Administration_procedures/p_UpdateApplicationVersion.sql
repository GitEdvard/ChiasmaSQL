use Administration
GO

/****** Object:  StoredProcedure [dbo].[p_UpdateApplicationVersion]    Script Date: 2014-02-27 14:07:56 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

-- Create a 'personal' devel database by cloning the common devel db backup in the merge folder
-- The database created will match the person calling this procedure
-- who must exists in tables map_devel_table and map_devel_user in Administration
-- Call procedure p_CreateDevelUserSQL if current user is not present in above tables

alter procedure p_UpdateApplicationVersion(
	@db varchar(255),
	@version_number varchar(255))

as
begin
SET NOCOUNT ON

declare @sql varchar(max)
declare @app_name varchar(255)

if @db like 'gtdb2%' begin
	set @app_name = 'chiasma'
end
else if @db like 'bookkeeping%' begin
	set @app_name = 'Order'
end
else if @db like 'qc%' begin
	set @app_name = 'SNP Quality Analysis Tool'
end
else begin
	raiserror('Unknown database to update', 15, 1)
	return
end

set @sql = '
use ' + @db + '
update application_version set version = ''' + @version_number + ''' where identifier = ''' + @app_name + ''''


exec (@sql)


SET NOCOUNT off
end
go


