USE [DBAMonitor]
GO
/****** Object:  StoredProcedure [dbo].[CleanUpShortHistory]    Script Date: 2013-11-27 10:18:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[CleanUpShortHistory](@no_days int)
AS  
begin

	SET NOCOUNT ON

	delete from dbo.Database_Size_Short_History 
	where DATEDIFF(day, Log_Date, getdate()) > @no_days


end
