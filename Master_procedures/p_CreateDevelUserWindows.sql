use Administration
GO

/****** Object:  StoredProcedure [dbo].[p_CreateDevelUserWindows]    Script Date: 2014-02-27 14:07:56 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

--Creates users for each database that is listed in file owner_dbs.txt for @user_name
--@user_name should match a ordinary windows user, including the domain name USER\
--directory for file: D:\Scripts\Anv?ndbara script\Skapa anv?ndare\Developers
--Also, user is added in table authority in GTDB2 and BookKeeping devel dbs


create procedure p_CreateDevelUserWindows(
	@user_name varchar(255), 
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


set @db_user_name = 'User_' + @last_name + @first_name

if not OBJECT_ID('tempdb..#owner') is null
begin
	drop table #owner
end

if not OBJECT_ID('tempdb..#owner2') is null
begin
	drop table #owner2
end


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

set @str = 'declare @command varchar(max)
set @command = ''''
'

-- Create login if needed
select @str = @str + 
'if not exists(select name from master.sys.server_principals where type = ''u'' and name = ''' + @user_name + ''')
begin
	set @command = @command + ''
	use master
	CREATE LOGIN [' + @user_name + '] FROM WINDOWS
	EXEC sp_addsrvrolemember ''''' + @user_name + ''''', ''''bulkadmin''''
	''
end
'

set @counter = 1
-- create users for owner dataabses if needed
while exists(select db from #owner2 where rn = @counter)
begin
	select @str = @str + 
		'if not exists(SELECT name FROM ' + db + '.sys.database_principals where type = ''u'' and name = ''' + @db_user_name + ''')
		begin
			set @command = @command + 
			''
			use ' + db + '
			create user ' + @db_user_name + ' for login [' + @user_name + ']
			exec sp_addrolemember ''''db_owner'''', ''''' + @db_user_name + '''''''
		end
		' 
	from #owner2 where rn = @counter
	set @counter = @counter + 1
end

-- add user to authority tables in gtdb2 and bookkeeping dbs
select @str = @str + 
'if not exists(select identifier from gtdb2_devel.dbo.authority where identifier = ''' + @user_name + ''')
begin
	set @command = @command + ''
	insert into gtdb2_devel.dbo.authority
	(identifier, name, user_type, account_status)
	values
	(''''' + @user_name + ''''', ''''' + @first_name + ' ' + @last_name +  ''''', ''''Developer'''', 1 )''
end
'

select @str = @str + 
'if not exists(select identifier from gtdb2_practice.dbo.authority where identifier = ''' + @user_name + ''')
begin
	set @command = @command + ''
	insert into gtdb2_practice.dbo.authority
	(identifier, name, user_type, account_status)
	values
	(''''' + @user_name + ''''', ''''' + @first_name + ' ' + @last_name +  ''''', ''''Developer'''', 1 )''
end
'

select @str = @str + 
'if not exists(select identifier from gtdb2_devel2.dbo.authority where identifier = ''' + @user_name + ''')
begin
	set @command = @command + ''
	insert into gtdb2_devel2.dbo.authority
	(identifier, name, user_type, account_status)
	values
	(''''' + @user_name + ''''', ''''' + @first_name + ' ' + @last_name +  ''''', ''''Developer'''', 1 )''
end
'


select @str = @str + 
'if not exists(select identifier from bookkeeping_devel.dbo.authority where identifier = ''' + @user_name + ''')
begin
	declare @pop1 int
	select @pop1 = place_of_purchase_id from bookkeeping_devel.dbo.place_of_purchase
	set @command = @command + ''
	insert into bookkeeping_devel.dbo.authority
	(identifier, name, user_type, account_status, place_of_purchase_id)
	values
	(''''' + @user_name + ''''', ''''' + @first_name + ' '+ @last_name +  ''''', ''''Developer'''', 1, '' + cast(@pop1 as varchar(10)) + '' )''
end
'

select @str = @str + 
'if not exists(select identifier from bookkeeping_practice.dbo.authority where identifier = ''' + @user_name + ''')
begin
	declare @pop2 int
	select @pop2 = place_of_purchase_id from bookkeeping_practice.dbo.place_of_purchase
	set @command = @command + ''
	insert into bookkeeping_practice.dbo.authority
	(identifier, name, user_type, account_status, place_of_purchase_id)
	values
	(''''' + @user_name + ''''', ''''' + @first_name + ' '+ @last_name +  ''''', ''''Developer'''', 1, '' + cast(@pop1 as varchar(10)) + '' )''
end
'


set @str = @str + 'select @command'

insert into @sqltable
exec (@str)

select @str = str from @sqltable

select (@str)



SET NOCOUNT off
end
go


