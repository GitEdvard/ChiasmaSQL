USE [bookkeeping_devel]
GO

/****** Object:  StoredProcedure [dbo].[p_RegretOrderPost_tv1]    Script Date: 2014-02-21 16:07:18 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO






CREATE PROCEDURE [dbo].[p_RegretOrderPost_tv1](
@id INTEGER)

AS
BEGIN
SET NOCOUNT ON

UPDATE post_table_version_1
SET 
	authority_id_orderer = NULL,
	order_date = NULL,
	arrival_date = NULL,
	arrival_sign = NULL,
	invoice_status = 'Incoming',
	authority_id_invoicer = NULL,
	invoice_date = NULL
WHERE post_id = @id
	
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update post with id:', 15, 1, @id)
	RETURN
END

SET NOCOUNT OFF
END





GO


