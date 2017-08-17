USE [BookKeeping_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_ResetPostInvoiceStatus_tv1]    Script Date: 11/20/2009 16:10:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_ResetPostInvoiceStatus_tv1](
@id INTEGER
)

AS
BEGIN
SET NOCOUNT ON

DECLARE @identifier VARCHAR(255)

--Create identifier

UPDATE post_table_version_1
SET 
	authority_id_invoicer = NULL,
	invoice_date = NULL,
	invoice_status = 'Incoming',
	authority_id_orderer = NULL,
	order_date = NULL,
	predicted_arrival = NULL,
	invoice_inst = 0,
	invoice_clin = 0,
	arrival_date = NULL,
	arrival_sign = NULL,
	invoice_absent = 0
WHERE post_id = @id
	
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update post with id:', 15, 1, @id)
	RETURN
END

SET NOCOUNT OFF
END
