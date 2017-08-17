USE [GTDB2_devel]
GO
/****** Object:  UserDefinedFunction [dbo].[fGetYYForward]    Script Date: 11/20/2009 14:10:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[fGetYYForward](@internal_report_id INTEGER, @marker_id INTEGER, @xx INTEGER, @yy INTEGER)
RETURNS INTEGER

AS
BEGIN

--Get forward information for marker
--if forward-top, just return the results from 
--internal_report_marker_stat
--if forward-bot, decide if the xx and yy results should be swopped:
--if the snipp is a AT or CG, do not swop, otherwise swop
DECLARE @is_top_in_forward BIT
DECLARE @variant CHAR(3)

SELECT TOP (1) @is_top_in_forward = avf.is_top_in_forward, @variant = av.variant FROM 
allele_variant_forward avf INNER JOIN
allele_variant av ON (avf.allele_variant_id = av.allele_variant_id)
WHERE avf.marker_id = @marker_id 
ORDER BY CAST(avf.version AS FLOAT) DESC

IF @is_top_in_forward IS NULL
BEGIN
	RETURN -1
END 

IF @is_top_in_forward = 1
BEGIN
	RETURN @yy
END

RETURN @xx


END


