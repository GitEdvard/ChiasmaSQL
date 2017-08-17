USE [bookkeeping_devel]
GO

/****** Object:  StoredProcedure [dbo].[p_CreateInvoiceCategory]    Script Date: 2014-02-27 14:07:56 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO






ALTER PROCEDURE [dbo].[p_CreateInvoiceCategory](
@identifier VARCHAR(255),
@number INTEGER
)

AS
BEGIN
SET NOCOUNT ON

DECLARE @invoice_category_id INTEGER

INSERT INTO invoice_category
(identifier,
number
)
VALUES
(@identifier,
@number
)

IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to create invoice category with identifier: %s', 15, 1, @identifier)
	RETURN
END

SET @invoice_category_id = NULL
SELECT @invoice_category_id = invoice_category_id FROM invoice_category WHERE identifier = @identifier
IF @invoice_category_id IS NULL
BEGIN
	RAISERROR('invoice_category_id for invoice_category was not found', 15, 1)
	RETURN
END

SELECT * FROM invoice_category_view
WHERE id = @invoice_category_id

SET NOCOUNT OFF
END





GO


