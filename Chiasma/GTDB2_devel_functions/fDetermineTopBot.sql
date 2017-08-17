USE [GTDB2_devel]
GO
/****** Object:  UserDefinedFunction [dbo].[fDetermineTopBot]    Script Date: 11/20/2009 14:09:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[fDetermineTopBot](@assay_id INTEGER)
RETURNS CHAR(1)

--Determines if the given assay is on the top or bottom strand as
--defined by Illumina. Returns 'T' or 'B', or NULL if the strand
--could not be defined.

AS
BEGIN

DECLARE @variant CHAR(3)
DECLARE @fivePrimeFlank VARCHAR(2000)
DECLARE @threePrimeFlank VARCHAR(2000)
DECLARE @currentFivePrimeBase CHAR(1)
DECLARE @currentThreePrimeBase CHAR(1)
DECLARE @currentPair CHAR(3)
DECLARE @n INTEGER
DECLARE @primerDir CHAR(1)

--Get the allele variants from the assay.
SELECT @variant = av.variant
FROM assay a
INNER JOIN allele_variant av ON av.allele_variant_id = a.allele_variant_id
WHERE a.assay_id = @assay_id

IF @variant IS NULL RETURN NULL

IF @variant = 'N/A' RETURN NULL


--Unambigous designation from the SNP type.
IF @variant = 'A/C' OR @variant = 'A/G' RETURN 'T'

IF @variant = 'C/T' OR @variant = 'G/T' RETURN 'B'

IF @variant = 'D/I' RETURN 'T'  --For deletions and insertions doesn't matter, pick top.

--Ambigous SNP type, must go to the flanking sequnces.
SELECT @fivePrimeFlank = fiveprime_flank FROM marker_details md
WHERE marker_id IN (SELECT marker_id FROM assay WHERE assay_id = @assay_id)

SELECT @threePrimeFlank = threeprime_flank FROM marker_details md
WHERE marker_id IN (SELECT marker_id FROM assay WHERE assay_id = @assay_id)

IF @fivePrimeFlank IS NULL OR @threePrimeFlank IS NULL RETURN NULL

--Now investigate how the assay direction is compared to the flanking sequence.
SELECT @primerDir = orientation
FROM primer p
INNER JOIN primer_set ps ON ps.primer_id = p.primer_id
WHERE ps.assay_id = @assay_id
AND p.type = 'extension'


--Check for valid values.
IF @primerDir IS NULL RETURN NULL

IF (NOT @primerDir = 'F') AND (NOT @primerDir = 'R') RETURN NULL 

--Now do the sequence walking.
SET @n = 1
WHILE @n <= LEN(@fivePrimeFlank) AND @n <= LEN(@threePrimeFlank)
BEGIN
	SET @currentFivePrimeBase = SUBSTRING(@fivePrimeFlank, LEN(@fivePrimeFlank)+1-@n, 1)
	SET @currentThreePrimeBase = SUBSTRING(@threePrimeFlank, @n, 1)

	--Check if are valid bases.
	IF (NOT @currentFivePrimeBase = 'A') AND (NOT @currentFivePrimeBase = 'C')
	AND (NOT @currentFivePrimeBase = 'G') AND (NOT @currentFivePrimeBase = 'T') 
	AND (NOT @currentFivePrimeBase = 'U') AND (NOT @currentFivePrimeBase = 'R') 
	AND (NOT @currentFivePrimeBase = 'Y') AND (NOT @currentFivePrimeBase = 'M') 
	AND (NOT @currentFivePrimeBase = 'K') AND (NOT @currentFivePrimeBase = 'W') 
	AND (NOT @currentFivePrimeBase = 'S') AND (NOT @currentFivePrimeBase = 'B') 
	AND (NOT @currentFivePrimeBase = 'D') AND (NOT @currentFivePrimeBase = 'H') 
	AND (NOT @currentFivePrimeBase = 'V') AND (NOT @currentFivePrimeBase = 'X')
	AND (NOT @currentFivePrimeBase = 'N') RETURN NULL

	IF (NOT @currentThreePrimeBase = 'A') AND (NOT @currentThreePrimeBase = 'C')
	AND (NOT @currentThreePrimeBase = 'G') AND (NOT @currentThreePrimeBase = 'T') 
	AND (NOT @currentThreePrimeBase = 'U') AND (NOT @currentThreePrimeBase = 'R') 
	AND (NOT @currentThreePrimeBase = 'Y') AND (NOT @currentThreePrimeBase = 'M') 
	AND (NOT @currentThreePrimeBase = 'K') AND (NOT @currentThreePrimeBase = 'W') 
	AND (NOT @currentThreePrimeBase = 'S') AND (NOT @currentThreePrimeBase = 'B') 
	AND (NOT @currentThreePrimeBase = 'D') AND (NOT @currentThreePrimeBase = 'H') 
	AND (NOT @currentThreePrimeBase = 'V') AND (NOT @currentThreePrimeBase = 'X')
	AND (NOT @currentThreePrimeBase = 'N') RETURN NULL
	
	--Create pair.
	SET @currentPair = @currentFivePrimeBase + '/' + @currentThreePrimeBase

	IF @currentPair = 'A/C' OR @currentPair = 'A/G' OR @currentPair = 'T/C' OR @currentPair = 'T/G'
	BEGIN
		IF @primerDir = 'F' RETURN 'T' ELSE RETURN 'B'
	END

	IF @currentPair = 'C/A' OR @currentPair = 'G/A' OR @currentPair = 'C/T' OR @currentPair = 'G/T'
	BEGIN
		IF @primerDir = 'F' RETURN 'B' ELSE RETURN 'T'
	END

	SET @n = @n + 1
END

RETURN NULL


END
