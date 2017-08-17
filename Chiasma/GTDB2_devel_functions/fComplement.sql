USE [GTDB2_devel]
GO
/****** Object:  UserDefinedFunction [dbo].[fComplement]    Script Date: 11/20/2009 14:09:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fComplement](@alleles VARCHAR(255), @assay_id INTEGER)
RETURNS VARCHAR(255)

-- THIS FUNCTION WILL CHECK IF THE EXTENSITON PRIMER IS
-- IN THE FORWARD OR THE BACKWARD DIRECTION.
-- IF BACKWARD IT WILL TAKE THE COMPLEMENT OF THE ALLELES...


AS
BEGIN

DECLARE @primer_id INTEGER
DECLARE @primer_ori CHAR(1)
DECLARE @return_alleles VARCHAR(255)

SET @return_alleles = ''
-- CHECKING IF THE SENT PRIMER IS A EXTENSION PRIMER
IF NOT EXISTS( SELECT assay_id FROM assay WHERE assay_id = @assay_id )
BEGIN
	RETURN 'FAILED'
END

-- PICKING OUT THE EXTENSTION PRIMER FOR THE ASSAY FIRST
SELECT @primer_id = MIN(p.primer_id) FROM 
	primer p, primer_set ps
	WHERE p.type = 'extension' AND ps.assay_id = @assay_id 
	AND ps.primer_id = p.primer_id

-- PICKING OUT THE ORIENTATION OF THE PRIMER

DECLARE @i INTEGER


SELECT @primer_ori = orientation FROM primer WHERE primer_id = @primer_id

IF @primer_ori = 'R' AND @alleles <> 'N/A'
BEGIN
	-- STEPPING THROUGH ALL THE ALLELES AND TAKING THE COMPLEMENT
	SET @i = 1 
	
	WHILE @i <= LEN(@alleles)
	BEGIN
		IF SUBSTRING(@alleles, @i, 1) = 'A'
		BEGIN
			SET @return_alleles = @return_alleles + 'T' + '/' 	
		END
		IF SUBSTRING(@alleles, @i, 1) = 'C'
		BEGIN
			SET @return_alleles = @return_alleles + 'G' + '/' 
		END
		IF SUBSTRING(@alleles, @i, 1) = 'G'
		BEGIN
			SET @return_alleles = @return_alleles + 'C' + '/' 
		END
		IF SUBSTRING(@alleles, @i, 1) = 'T'
		BEGIN
			SET @return_alleles = @return_alleles + 'A' + '/' 
		END
		
		SET @i = @i + 2
	END
	SET @return_alleles = REVERSE(@return_alleles)	
	-- REMOVING THE FIRST '/' BEFORE RETURNING THE ALLELES
	SET @return_alleles = SUBSTRING(@return_alleles, 2, LEN(@return_alleles))
END
ELSE
BEGIN
	SET @return_alleles = @alleles
END

		
RETURN @return_alleles
END



