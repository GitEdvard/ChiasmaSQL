use Auxilliary
go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION dbo.fn_ParsePosY(@well_position varchar(10))
RETURNS int
AS
BEGIN
     RETURN ascii(substring(@well_position, 1,1)) - ascii('A') + 1 
END;
GO
