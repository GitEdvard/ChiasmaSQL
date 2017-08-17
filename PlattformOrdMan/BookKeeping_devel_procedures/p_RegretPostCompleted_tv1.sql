USE [BookKeeping_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_OrderPost]    Script Date: 11/20/2009 16:10:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_RegretPostCompleted_tv1](
@id INTEGER)

AS
BEGIN
SET NOCOUNT ON

UPDATE post_table_version_1
SET 
	invoice_status = 'Incoming',
	authority_id_invoicer = NULL,
	invoice_absent = 0,
	invoice_date = NULL
WHERE post_id = @id
	
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update post with id:', 15, 1, @id)
	RETURN
END

SET NOCOUNT OFF
END
