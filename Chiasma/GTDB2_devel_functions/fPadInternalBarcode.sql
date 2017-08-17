USE [GTDB2_devel]
GO
/****** Object:  UserDefinedFunction [dbo].[fPadInternalBarcode]    Script Date: 11/20/2009 14:10:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fPadInternalBarcode](@code_length tinyint, @proposedCodeValue int)
RETURNS VARCHAR(255)


AS
BEGIN
DECLARE @proposedCodeString VARCHAR(255)
DECLARE @leadingPads INT
DECLARE @offset INT
DECLARE @missingZeros INT
declare @convertedBarcode varchar(255)

set @convertedBarcode = cast(@proposedCodeValue as varchar(255))

SET @leadingPads = @code_length - LEN(@convertedBarcode) 
IF @leadingPads > 0
	SET @offset = 1
ELSE
	SET @offset = 0

SET @missingZeros = @leadingPads - @offset

SET @proposedCodeString = REPLICATE('1', @offset) + REPLICATE('0', @missingZeros) + @convertedBarcode

RETURN @proposedCodeString
END
