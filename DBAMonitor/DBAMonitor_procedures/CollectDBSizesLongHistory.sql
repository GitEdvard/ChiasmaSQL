USE [DBAMonitor]
GO
/****** Object:  StoredProcedure [dbo].[CollectDBSizesLongHistory]    Script Date: 2013-11-27 10:18:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[CollectDBSizesLongHistory]
AS  
begin

	SET NOCOUNT ON

	declare @dbsize table(
		Dbname varchar(30),
		file_Size_MB decimal(20,2)default (0),
		Space_Used_MB decimal(20,2)default (0),
		Free_Space_MB decimal(20,2) default (0)
		)

	declare @logsize table(
		Dbname varchar(30), 
		Log_File_Size_MB decimal(20,2)default (0),
		log_Space_Used_MB decimal(20,2)default (0),
		log_Free_Space_MB decimal(20,2)default (0)
		)

	declare @alldbstate table(
		dbname varchar(25),
		DBstatus varchar(25),
		R_model Varchar(20)
		)

	insert into @dbsize(Dbname,file_Size_MB,Space_Used_MB,Free_Space_MB)
	exec sp_msforeachdb
	'use [?];
	  select DB_NAME() AS DbName,
	sum(size)/128.0 AS File_Size_MB,
	sum(CAST(FILEPROPERTY(name, ''SpaceUsed'') AS INT))/128.0 as Space_Used_MB,
	SUM( size)/128.0 - sum(CAST(FILEPROPERTY(name,''SpaceUsed'') AS INT))/128.0 AS Free_Space_MB 
	from sys.database_files  where type=0 group by type' 


	-------------------log size--------------------------------------
	insert into @logsize(Dbname,Log_File_Size_MB,log_Space_Used_MB,log_Free_Space_MB)
	exec sp_msforeachdb
	'use [?];
	  select DB_NAME() AS DbName,
	sum(size)/128.0 AS Log_File_Size_MB,
	sum(CAST(FILEPROPERTY(name, ''SpaceUsed'') AS INT))/128.0 as log_Space_Used_MB,
	SUM( size)/128.0 - sum(CAST(FILEPROPERTY(name,''SpaceUsed'') AS INT))/128.0 AS log_Free_Space_MB 
	from sys.database_files  where type=1 group by type'

	-----------------------------------
 
	insert into @alldbstate (dbname,DBstatus,R_model)
	select name,CONVERT(varchar(20),DATABASEPROPERTYEX(name,'status')),recovery_model_desc from sys.databases
 
	insert into @dbsize(Dbname)
	select dbname from @alldbstate where DBstatus <> 'online'
 
	insert into @logsize(Dbname)
	select dbname from @alldbstate where DBstatus <> 'online'
 

	insert into dbo.Database_Size_Long_History
	(
		DBname, file_Size_MB,Space_Used_MB,
		Free_Space_MB,Log_File_Size_MB,log_Space_Used_MB,
		log_Free_Space_MB
	)
	select 
		d.Dbname, 
		d.file_Size_MB,
		d.Space_Used_MB,
		d.Free_Space_MB,
		l.Log_File_Size_MB,
		l.log_Space_Used_MB,
		l.log_Free_Space_MB
	from @dbsize d join @logsize l on d.Dbname=l.Dbname 
	order by Dbname

end
