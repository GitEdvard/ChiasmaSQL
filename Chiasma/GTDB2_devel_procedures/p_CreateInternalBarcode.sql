USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreateInternalBarcode]    Script Date: 11/16/2009 13:37:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
--INSERTS A NEW INTERNAL BAR CODE WITH @code_length NUMBER OF DIGITS INTO THE 
--DATABASE AND ASSOCIATES THE BAR CODE WITH THE identifiable_id.
-- Identifiable_id and kind may be null if we want to create a bar code that are not yet associated to an object in the database.

ALTER PROCEDURE [dbo].[p_CreateInternalBarcode] (
	@identifiable_id INTEGER = NULL,
	@kind VARCHAR(32) = NULL,
	@code_length TINYINT)
AS
BEGIN
SET NOCOUNT ON

DECLARE @highestInternalCode INT
DECLARE @kind_id INTEGER
DECLARE @proposedCodeValue VARCHAR(255)
DECLARE @proposedCodeString VARCHAR(255)
DECLARE @missingZeros INT
DECLARE @leadingPads INT
DECLARE @offset INT

--FIND THE HIGHEST EXISTING INTERNAL CODE.
SELECT TOP 1 @highestInternalCode = CAST(code AS INT) FROM internal_barcode 
ORDER BY CAST(code AS INT) DESC

IF @highestInternalCode IS NULL
BEGIN
	SET @highestInternalCode = 0
END

--PROPOSE THE NEW CODE THE BE ONE HIGHER THAN THE HIGHEST EXISTING INTERNAL CODE.
SET @proposedCodeValue = CAST((@highestInternalCode + 1) AS VARCHAR(255))

--PAD THE CODE STRING WITH LEADING ZEROS.
IF LEN(@proposedCodeValue) > @code_length
BEGIN
	RAISERROR('Cannot generate a new barcode with the specified length', 15, 1)
	RETURN	
END 

set @proposedCodeString = dbo.fPadInternalBarcode(@code_length, @highestInternalCode + 1)

--REPEAT AS LONG AS AN EXTERNAL BAR CODE EXISTS WHICH IS EXACTLY THE SAME
--AS THE PROPOSED NEW CODE.
WHILE (EXISTS(SELECT * FROM external_barcode WHERE code = @proposedCodeString))
BEGIN
	SET @proposedCodeValue = @proposedCodeValue + 1

	--PAD THE CODE STRING WITH LEADING ZEROS.
	IF LEN(@proposedCodeValue) > @code_length
	BEGIN
		RAISERROR('Cannot generate a new barcode with the specified length', 15, 1)
		RETURN	
	END 
	SET @leadingPads = @code_length - LEN(@proposedCodeValue) 
	IF @leadingPads > 0
		SET @offset = 1
	ELSE
		SET @offset = 0

	SET @missingZeros = @leadingPads - @offset

	SET @proposedCodeString = REPLICATE('1', @offset) + REPLICATE('0', @missingZeros) + @proposedCodeValue
END

-- Get kind id.
SET @kind_id = NULL
IF @kind IS NOT NULL
BEGIN
	SELECT @kind_id = kind_id FROM kind WHERE name = @kind
	IF @kind_id IS NULL
	BEGIN
		RAISERROR('Failed to create bar code with code: %s', 15, 1, @proposedCodeString)
		RETURN
	END
END

--Create this bar code.
INSERT INTO internal_barcode (code, identifiable_id, kind_id)
VALUES (@proposedCodeString, @identifiable_id, @kind_id)
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to create bar code with code: %s', 15, 1, @proposedCodeString)
	RETURN
END

SELECT @proposedCodeString AS barcode

SET NOCOUNT OFF
END
