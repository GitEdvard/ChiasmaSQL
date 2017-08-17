use Auxilliary
go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION dbo.fn_ParsePosX(@well_position varchar(10))
RETURNS int
AS
BEGIN
     RETURN cast(SUBSTRING(@well_position, 2,2) as int) 
END;
GO
