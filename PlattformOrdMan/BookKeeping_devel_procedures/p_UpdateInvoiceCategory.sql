USE [BookKeeping_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdateInvoiceCategory]    Script Date: 11/20/2009 16:10:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_UpdateInvoiceCategory](
@id INTEGER,
@identifier VARCHAR(255),
@number INTEGER
)

AS
BEGIN
SET NOCOUNT ON

UPDATE invoice_category
SET identifier = @identifier,
	number = @number
WHERE invoice_category_id = @id

IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update invoice category with identifier: %s', 15, 1, @identifier)
	RETURN
END

SET NOCOUNT OFF
END
