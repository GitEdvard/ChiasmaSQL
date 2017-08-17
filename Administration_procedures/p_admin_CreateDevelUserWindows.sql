use Administration
GO

/****** Object:  StoredProcedure [dbo].[p_admin_CreateDevelUserWindows]    Script Date: 2014-02-27 14:07:56 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

-- Before calling this proc, use separate script (the common script) to add user to operational databases!

--Creates users for each database that is listed in file owner_dbs.txt for @login_name
--@login_name should match a ordinary windows user, including the domain name USER\
--directory for file: D:\Scripts\Anv?ndbara script\Skapa anv?ndare\Developers
--Also, user is added in table authority in GTDB2 and BookKeeping devel dbs



alter procedure p_admin_CreateDevelUserWindows(
	@login_name varchar(255), 
	@first_name varchar(255), 
	@last_name varchar(255))
as
begin
SET NOCOUNT ON

declare @counter int
declare @command1 varchar(max)
declare @str varchar(max)
declare @sqltable table(str varchar(max))
declare @db_user_name varchar(255)
declare @dbs table (db varchar(20))
declare @current_db varchar(20)


set @db_user_name = 'User_' + @last_name + @first_name

if not OBJECT_ID('tempdb..#owner') is null
begin
	drop table #owner
end

if not OBJECT_ID('tempdb..#owner2') is null
begin
	drop table #owner2
end

--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
-- Create temp tables
--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
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

-- Generate scripts

set @counter = 1

set @str = ''

--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
-- Create login if needed
--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
select @str = @str + 
'if not exists(select name from master.sys.server_principals where type = ''u'' and name = ''' + @login_name + ''')
begin
	use master
	CREATE LOGIN [' + @login_name + '] FROM WINDOWS
	alter server role bulkadmin add member [' + @login_name + ']
end
'

--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
-- Create users for all devel databases
--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
delete from @dbs

insert into @dbs 
(db)
select name from master.sys.databases 
where name like 'gtdb2_devel%' 
	or name like 'bookkeeping_devel%'
	or name like 'qc_devel%'
	or name like 'fp_devel%'

declare cur cursor local for
select db from @dbs

open cur
fetch next from cur into @current_db
while @@FETCH_STATUS = 0 begin
	set @str = @str + '
	use ' + @current_db + '
	if not exists(select * from ' + @current_db + '.sys.database_principals where type = ''u'' and name = ''' + @db_user_name + ''') begin
		create user ' + @db_user_name + ' for login [' + @login_name + ']
	end
	alter role db_owner add member ' + @db_user_name + '
	'
	fetch next from cur into @current_db
end

close cur

deallocate cur

exec (@str)

set @str = ''

--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
-- add user to authority tables in gtdb2 and bookkeeping dbs
--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

-- GTDB2_devel-dbs
delete from @dbs
insert into @dbs
(db)
select name from master.sys.databases where name like 'gtdb2%'

declare cur cursor local for
select db from @dbs

open cur

fetch next from cur into @current_db

while @@FETCH_STATUS = 0 begin
	set @str = @str + '
	if not exists (select identifier from ' + @current_db + '.dbo.authority where identifier = ''' + @login_name + ''')
	begin
		insert into ' + @current_db + '.dbo.authority
		(identifier, name, user_type, account_status)
		values
		(''' + @login_name + ''', ''' + @first_name + ' ' + @last_name + ''', ''Developer'', 1)
	end
	'
	fetch next from cur into @current_db
end


close cur

deallocate cur

-- BookKeeping_devel-dbs

delete from @dbs
insert into @dbs
select name from master.sys.databases where name like 'bookkeeping%'

declare cur cursor local for
select db from @dbs

open cur 

fetch next from cur into @current_db

while @@FETCH_STATUS = 0 begin
	set @str = @str + '
	use ' + @current_db + '
	if not exists (select identifier from ' + @current_db + '.dbo.authority where identifier = ''' + @login_name + ''')
	begin
		insert into authority
		(identifier, name, user_type, account_status, place_of_purchase_id)
		select top(1) ''' + @login_name + ''', ''' + @first_name + ' ' + @last_name + ''', ''Developer'', 1, place_of_purchase_id
			from place_of_purchase
	end
	'
	fetch next from cur into @current_db
end


close cur

deallocate cur

exec (@str)

--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
-- Add user in table client_logins
--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

if not exists(select * from client_logins where login = @login_name) begin
	insert into client_logins
	(login, alias, db_user_name)
	values
	(@login_name, @first_name + ' ' + @last_name, @db_user_name)
end


SET NOCOUNT off
end
go


