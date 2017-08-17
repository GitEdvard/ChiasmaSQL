use Administration
GO

/****** Object:  StoredProcedure [dbo].[p_CreateDevelUserSQL]    Script Date: 2014-02-27 14:07:56 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

--Creates script to create server login (SQL) and users for each (relevant) database for @login_name
-- Initial password is "molmed2015"
--read only databases are listed in readonly_dbs.txt 
--owner databases are listed in owner_dbs.txt in 
--directory: D:\Scripts\Anv?ndbara script\Skapa anv?ndare\Developers
--Also, user is added in table authority in GTDB2 and BookKeeping devel dbs

-- Parameters
-- @login_name: Login name for sql-user (restricted permissions), the login and db -users will be created in this script
-- @sys_admin_login_name: sysadmin login name, should already been created before the call to this procedure
-- @devel_db_name: Name of the 'personal' devel db, e.g. GTDB2_devel_<initials>

create procedure p_CreateDevelUserSQL(
	@login_name varchar(255),
	@sys_admin_login_name varchar(255),
	@initials varchar(255)
)
as
begin
SET NOCOUNT ON

declare @counter int
declare @command1 varchar(max)
declare @str varchar(max)
declare @sqltable table(str varchar(max))
declare @devel_user_name varchar(255)

set @devel_user_name = 'User_' + @login_name


if not OBJECT_ID('tempdb..#readonly') is null
begin
	drop table #readonly
end
if not OBJECT_ID('tempdb..#readonly2') is null
begin
	drop table #readonly2
end

if not OBJECT_ID('tempdb..#owner') is null
begin
	drop table #owner
end

if not OBJECT_ID('tempdb..#owner2') is null
begin
	drop table #owner2
end

if not OBJECT_ID('tempdb..#op_dbs') is null
begin
	drop table #op_dbs
end

if not OBJECT_ID('tempdb..#op_dbs2') is null
begin
	drop table #op_dbs2
end


create table #readonly(db varchar(255))
bulk insert #readonly from 'D:\Scripts\Proc_references\Devel_user_dbs\readonly_dbs.txt'
with 
(
	rowterminator = '\n'
)

create table #readonly2 (
db varchar(255),
rn int)

insert into #readonly2
(db, rn)
select db, ROW_NUMBER() over (order by db desc) from #readonly

create table #owner (db varchar(235))
bulk insert #owner from 'D:\Scripts\Proc_references\Devel_user_dbs\owner_dbs.txt'
with 
(
	rowterminator = '\n'
)
create table #owner2(
	db varchar(255),
	rn int)
insert into #owner2
(db, rn)
select db, ROW_NUMBER() over (order by db desc) from #owner

create table #op_dbs (db varchar(235))
bulk insert #op_dbs from 'D:\Scripts\Proc_references\Devel_user_dbs\operational_dbs.txt'
with 
(
	rowterminator = '\n'
)
create table #op_dbs2(
	db varchar(255),
	rn int)
insert into #op_dbs2
(db, rn)
select db, ROW_NUMBER() over (order by db desc) from #op_dbs

-- Generate scripts

set @counter = 1

set @str = 'declare @command varchar(max)
set @command = ''''
'

-- Create login if needed
select @str = @str + 
'if not exists(select name from master.sys.server_principals where type = ''s'' and name = ''' + @login_name + ''')
begin
	set @command = @command + ''
	use master
	CREATE LOGIN ' + @login_name + ' with password = ''''molmed2015'''' 
	EXEC sp_addsrvrolemember ''''' + @login_name + ''''', ''''bulkadmin''''
	''
end
'

-- create users for read only databases, if needed
while exists( select db from #readonly2 where rn = @counter)
begin
	select @str = @str  + 
		'if not exists(SELECT name FROM ' + db + '.sys.database_principals where type = ''s'' and name = ''' + @devel_user_name + ''')
		begin
			set @command = @command + 
			''
			use ' + db + '
			create user ' + @devel_user_name + ' for login ' + @login_name + '
			exec sp_addrolemember ''''db_datareader'''', ''''' + @devel_user_name + '''''''
		end
		' 
	from #readonly2 where rn = @counter

	set @counter = @counter + 1
end

set @counter = 1
-- create users for owner dataabses if needed
while exists(select db from #owner2 where rn = @counter)
begin
	select @str = @str + 
		'if not exists(SELECT name FROM ' + db + '.sys.database_principals where type = ''s'' and name = ''' + @devel_user_name + ''')
		begin
			set @command = @command + 
			''
			use ' + db + '
			create user ' + @devel_user_name + ' for login ' + @login_name + '
			exec sp_addrolemember ''''db_owner'''', ''''' + @devel_user_name + '''''''
		end
		' 
	from #owner2 where rn = @counter
	set @counter = @counter + 1
end

-- add user to master database
select @str = @str + 
'if not exists(select name from master.sys.database_principals where type = ''s'' and name = ''' + @devel_user_name + ''')
begin
	set @command = @command + 
	''
	use master
	create user ' + @devel_user_name + ' for login ' + @login_name + '
	exec sp_addrolemember ''''develuser'''', ''''' + @devel_user_name + '''''''
end
'

-- add user to authority tables in gtdb2 and bookkeeping dbs
select @str = @str + 
'if not exists(select name from gtdb2_devel.sys.database_principals where type = ''s'' and name = ''' + @devel_user_name + ''')
begin
	set @command = @command + ''
	insert into gtdb2_devel.dbo.authority
	(identifier, name, user_type, account_status)
	values
	(''''' + @login_name + ''''', ''''' + @login_name + ''''', ''''Developer'''', 1 )''
end
'

select @str = @str + 
'if not exists(select name from gtdb2_practice.sys.database_principals where type = ''s'' and name = ''' + @devel_user_name + ''')
begin
	set @command = @command + ''
	insert into gtdb2_practice.dbo.authority
	(identifier, name, user_type, account_status)
	values
	(''''' + @login_name + ''''', ''''' + @login_name + ''''', ''''Developer'''', 1 )''
end
'

select @str = @str + 
'if not exists(select name from bookkeeping_devel.sys.database_principals where type = ''s'' and name = ''' + @devel_user_name + ''')
begin
	declare @pop1 int
	select @pop1 = place_of_purchase_id from bookkeeping_devel.dbo.place_of_purchase
	set @command = @command + ''
	insert into bookkeeping_devel.dbo.authority
	(identifier, name, user_type, account_status, place_of_purchase_id)
	values
	(''''' + @login_name + ''''', ''''' + @login_name + ''''', ''''Developer'''', 1, '' + cast(@pop1 as varchar(10)) + '' )''
end
'

select @str = @str + 
'if not exists(select name from bookkeeping_practice.sys.database_principals where type = ''s'' and name = ''' + @devel_user_name + ''')
begin
	declare @pop2 int
	select @pop2 = place_of_purchase_id from bookkeeping_practice.dbo.place_of_purchase
	set @command = @command + ''
	insert into bookkeeping_practice.dbo.authority
	(identifier, name, user_type, account_status, place_of_purchase_id)
	values
	(''''' + @login_name + ''''', ''''' + @login_name + ''''', ''''Developer'''', 1, '' + cast(@pop2 as varchar(10))+ '')''
end
'


-- Map login name with devel db name


set @counter = 1
declare @devel_db_name varchar(255)

-- loop over all operational dbs
while exists( select db from #op_dbs2 where rn = @counter)
begin
	select @devel_db_name = db + '_devel_' + @initials
		from #op_dbs2 where rn = @counter
	-- Create map between sql and devel dbs
	select @str = @str + 
'
if not exists(select * from master.dbo.map_devel_table where login = ''' + @login_name + ''') begin
	set @command = @command + ''
	insert into master.dbo.map_devel_table
	(login, devel_db_name, operation_db_name)
	values
	(''''' + @login_name + ''''', ''''' + @devel_db_name + ''''', ''''' + db + ''''')''  
end
else begin
	set @command = @command + ''
	update master.dbo.map_devel_table set 
		devel_db_name = ''''' + @devel_db_name + '''''
		where login = ''''' + @login_name + ''''' and operation_db_name = ''''' + db + '''''''
end
'
	from #op_dbs2 where rn = @counter

	-- Create map between sysadmin login and devel dbs
	select @str = @str + 
'
if not exists(select * from master.dbo.map_devel_table where login = ''' + @sys_admin_login_name + ''') begin
	set @command = @command + ''
	insert into master.dbo.map_devel_table
	(login, devel_db_name, operation_db_name)
	values
	(''''' + @sys_admin_login_name + ''''', ''''' + @devel_db_name + ''''', ''''' + db + ''''')''  
end
else begin
	set @command = @command + ''
	update master.dbo.map_devel_table set 
		devel_db_name = ''''' + @devel_db_name + '''''
		where login = ''''' + @sys_admin_login_name + ''''' and operation_db_name = ''''' + db + '''''''
end
'
	from #op_dbs2 where rn = @counter
	
	set @counter = @counter + 1
end



-- Map login name with devel user name in 'personal' devel-db
select @str = @str + 
'
if not exists(select * from master.dbo.map_devel_user where login = ''' + @login_name + ''') begin
	set @command = @command + ''
	insert into master.dbo.map_devel_user
	(login, devel_user)
	values
	(''''' + @login_name + ''''', ''''' + @devel_user_name + ''''')''
end
else begin
	set @command = @command + ''
	update master.dbo.map_devel_user set 
		devel_user = ''''' + @devel_user_name + '''''
	where login = ''''' + @login_name + '''''''
end
'

select @str = @str + 
'
if not exists(select * from master.dbo.map_devel_user where login = ''' + @sys_admin_login_name + ''') begin
	set @command = @command + ''
	insert into master.dbo.map_devel_user
	(login, devel_user)
	values
	(''''' + @sys_admin_login_name + ''''', ''''' + @devel_user_name + ''''')''
end
else begin
	set @command = @command + ''
	update master.dbo.map_devel_user set 
		devel_user = ''''' + @devel_user_name + '''''
	where login = ''''' + @sys_admin_login_name + '''''''
end
'

set @str = @str + 'select @command'

insert into @sqltable
exec (@str)

select @str = str from @sqltable

exec (@str)

exec p_CloneGTDB2DevelLatestReleaseAdmin @devel_login = @login_name



SET NOCOUNT off
end
go


