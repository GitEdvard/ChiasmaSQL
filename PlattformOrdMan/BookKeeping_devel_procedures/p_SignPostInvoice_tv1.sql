USE [BookKeeping_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_SignPostInvoice_tv1]    Script Date: 11/20/2009 16:10:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_SignPostInvoice_tv1](
@id INTEGER,
@authority_id_invoicer INTEGER,
@invoice_status VARCHAR(20),
@invoice_absent BIT
)

AS
BEGIN
SET NOCOUNT ON

UPDATE post_table_version_1
SET 
	authority_id_invoicer = @authority_id_invoicer,
	invoice_date = GETDATE(),
	invoice_status = @invoice_status,
	invoice_absent = @invoice_absent
WHERE post_id = @id
	
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update post with id:', 15, 1, @id)
	RETURN
END

SET NOCOUNT OFF
END
