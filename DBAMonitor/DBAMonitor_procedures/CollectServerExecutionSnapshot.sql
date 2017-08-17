USE [DBAMonitor]
GO
/****** Object:  StoredProcedure [dbo].[CollectServerExecutionSnapshot]    Script Date: 2013-11-27 10:17:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[CollectServerExecutionSnapshot]  
AS  
SET NOCOUNT ON
SELECT   
	  SDES.login_time  
	  , SDES.login_name  
	  , SDES.host_name as HostName  
	  , CASE     
			WHEN SDER.[statement_start_offset] > 0 THEN    
				CASE SDER.[statement_end_offset]    
					WHEN -1 THEN    
						SUBSTRING(DEST.TEXT, (SDER.[statement_start_offset]/2) + 1, 2147483647)   
					ELSE     
						SUBSTRING(DEST.TEXT, (SDER.[statement_start_offset]/2) + 1, (SDER.[statement_end_offset] - SDER.[statement_start_offset])/2)     
					END    
			ELSE    
				CASE SDER.[statement_end_offset]    
					WHEN -1 THEN    
						RTRIM(LTRIM(DEST.[text]))    
					ELSE    
						LEFT(DEST.TEXT, (SDER.[statement_end_offset]/2) +1)    
					END    
			END AS [Executing_Statement]    
	  , DEST.[text] AS [Full_Statement_Code]   
	  , sder.Status  
	  , sder.Command  
	  , db_name(sder.database_id) as Database_Name   
	  , sder.blocking_session_id  
	  , sder.wait_type  
	  , sder.last_wait_type  
	  , sder.wait_time  
	  , sder.cpu_time  
	  , sder.total_elapsed_time  
	  , sder.reads  
	  , sder.writes  
	  , sder.logical_reads  
	  , sder.row_count  
	  , sder.granted_query_memory  
	  , getdate() as [Snapshot_Date]  
	  , sder.plan_handle  
	  , sder.session_id
	  , wait_resource 
	  , SDES.open_transaction_count 
INTO	[#Server_Exec_Monitor]    
FROM	sys.[dm_exec_requests] SDER CROSS APPLY   
		sys.[dm_exec_sql_text](SDER.[sql_handle]) DEST  LEFT JOIN sys.dm_exec_sessions SDES  
		ON SDER.SESSION_ID = SDES.SESSION_ID    
WHERE	SDER.session_id > 50    
ORDER By  1 desc  

DELETE	FROM  [#Server_Exec_Monitor]  
		WHERE executing_statement like '%WAITFOR%'  

DELETE	FROM  [#Server_Exec_Monitor]  
		WHERE executing_statement like '%ServerCodeExecSnapshot%'  

DELETE	FROM  [#Server_Exec_Monitor]  
		WHERE executing_statement like '%Server_Exec_Monitor%'  

DELETE	FROM  [#Server_Exec_Monitor]  
		WHERE Database_Name = 'dbamonitor'  


INSERT INTO [Server_Exec_Monitor]  
SELECT * FROM [#Server_Exec_Monitor]  

IF (select DATEPART(weekday, getdate())) = 5 AND (select DATEPART(HOUR, getdate())) = 11 AND (select DATEPART(MINUTE, getdate())) = 1  
		DELETE	FROM  [Server_Exec_Monitor]  
		WHERE   Snapshot_Date < getdate() - 14  

DROP TABLE #Server_Exec_Monitor  
