USE [BookKeeping_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreateInvoice]    Script Date: 11/20/2009 16:10:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_CreateInvoice](
@identifier VARCHAR(255),
@order_summary_id int,
@internal_identifier VARCHAR(255) = null
)

AS
BEGIN
SET NOCOUNT ON

INSERT INTO invoice
(identifier,
internal_identifier,
order_summary_id)
VALUES
(@identifier,
@internal_identifier,
@order_summary_id
)
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to create invoice with identifier: %s', 15, 1, @identifier)
	RETURN
END

SELECT * from invoice_view
WHERE id = scope_identity()

SET NOCOUNT OFF
END
