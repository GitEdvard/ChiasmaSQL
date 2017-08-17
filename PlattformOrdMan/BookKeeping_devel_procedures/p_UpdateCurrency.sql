USE [BookKeeping_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdateUser]    Script Date: 11/20/2009 16:09:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_UpdateCurrency](
@currency_id INTEGER,
@identifier VARCHAR(255) = NULL,
@currency_code VARCHAR(3) = NULL,
@symbol NVARCHAR(20) = NULL
)

AS
BEGIN
SET NOCOUNT ON

UPDATE currency SET
identifier = @identifier,
currency_code = @currency_code,
symbol = @symbol
WHERE currency_id = @currency_id

SET NOCOUNT OFF
END
