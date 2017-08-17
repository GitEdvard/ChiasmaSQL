
USE [GTDB2_devel]
GO
/****** Object:  UserDefinedFunction [dbo].[fGetYY]    Script Date: 11/20/2009 14:10:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fGetYY](@internal_report_id INTEGER, 
	@marker_id INTEGER, 
	@xx_top INTEGER, 
	@yy_top INTEGER,
	@strand_reference VARCHAR(10))
RETURNS INTEGER

AS
BEGIN

--Get forward/plus information for marker
--if forward-top/plus-top, just return the results from 
--internal_report_marker_stat
--if forward-bot/plus-bot, swop
DECLARE @is_top BIT

IF @strand_reference = 'FORWARD'
BEGIN
	SELECT TOP (1) @is_top = avf.is_top_in_forward FROM 
	allele_variant_forward avf INNER JOIN
	allele_variant av ON (avf.allele_variant_id = av.allele_variant_id)
	WHERE avf.marker_id = @marker_id 
	ORDER BY CAST(avf.version AS FLOAT) DESC
END
ELSE IF @strand_reference = 'PLUS'
BEGIN
	SELECT @is_top = avp.is_top_in_plus FROM 
	allele_variant_plus avp INNER JOIN
	allele_variant av ON (avp.allele_variant_id = av.allele_variant_id)
	WHERE avp.marker_id = @marker_id 
END
ELSE IF @strand_reference = 'TOP'
BEGIN
	SET @is_top = 1
END


IF @is_top IS NULL
BEGIN
	RETURN -1
END 

IF @is_top = 1
BEGIN
	RETURN @yy_top
END

RETURN @xx_top


END


