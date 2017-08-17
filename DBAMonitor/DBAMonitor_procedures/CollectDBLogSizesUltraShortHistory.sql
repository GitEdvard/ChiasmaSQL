USE [DBAMonitor]
GO
/****** Object:  StoredProcedure [dbo].[CollectDBSizesShortHistory]    Script Date: 2013-11-27 10:18:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
alter procedure [dbo].[CollectDBLogSizesUltraShortHistory]
AS  
begin

	SET NOCOUNT ON

	declare @logsize table(
		Dbname varchar(30), 
		Log_File_Size_MB decimal(20,2)default (0),
		log_Space_Used_MB decimal(20,2)default (0),
		log_Free_Space_MB decimal(20,2)default (0)
		)

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
  

	insert into dbo.Database_Log_Size_Ultra_Short_History
	(
		DBname,Log_File_Size_MB,log_Space_Used_MB,
		log_Free_Space_MB
	)
	select 
		l.Dbname, 
		l.Log_File_Size_MB,
		l.log_Space_Used_MB,
		l.log_Free_Space_MB
	from @logsize l 
	order by Dbname

end
