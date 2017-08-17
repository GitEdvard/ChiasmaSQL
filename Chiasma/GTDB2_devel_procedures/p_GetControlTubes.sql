USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetControlTubes]    Script Date: 11/20/2009 15:57:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
-- 7/5 2009, ändrar så att den bara hanterar rör
ALTER PROCEDURE [dbo].[p_GetControlTubes] 
	-- Add the parameters for the stored procedure here
	@p1 varchar(50) = ' '
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


select * from tube_sample_view tsv
INNER JOIN 
	individual i ON i.individual_id = tsv.sample_individual_id
WHERE i.individual_usage = @p1 
	
END

