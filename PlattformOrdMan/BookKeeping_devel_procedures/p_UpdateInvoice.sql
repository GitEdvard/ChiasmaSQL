USE [BookKeeping_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdateInvoice]    Script Date: 11/20/2009 16:10:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_UpdateInvoice](
@id INTEGER,
@identifier VARCHAR(255),
@authority_id_checker int,
@check_date datetime,
@status varchar(20),
@internal_identifier varchar(255),
@order_summary_id int
)

AS
BEGIN
SET NOCOUNT ON

UPDATE invoice
SET 
	identifier = @identifier,
	authority_id_checker = @authority_id_checker,
	check_date = @check_date,
	status = @status,
	internal_identifier = @internal_identifier,
	order_summary_id = @order_summary_id
WHERE invoice_id = @id

IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update invoice with identifier: %s', 15, 1, @identifier)
	RETURN
END

SET NOCOUNT OFF
END
