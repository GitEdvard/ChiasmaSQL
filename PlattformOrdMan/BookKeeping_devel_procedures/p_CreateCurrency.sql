USE [BookKeeping_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreateUser]    Script Date: 11/20/2009 16:09:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[p_CreateCurrency](
@identifier VARCHAR(255) = NULL,
@currency_code VARCHAR(3) = NULL,
@symbol nvarchar(20) = NULL
)

AS
BEGIN
SET NOCOUNT ON

DECLARE @currency_id INT

INSERT INTO currency
(identifier,
currency_code,
symbol)
VALUES
(@identifier,
@currency_code,
@symbol
)

SET @currency_id = SCOPE_IDENTITY()

SELECT * from currency_view
WHERE currency_id = @currency_id

SET NOCOUNT OFF
END
