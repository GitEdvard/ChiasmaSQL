USE [BookKeeping_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_DeleteInvoice]    Script Date: 03/25/2010 15:48:40 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_DeleteInvoice](
@id INTEGER
)

AS
BEGIN
SET NOCOUNT ON

DELETE FROM invoice WHERE invoice_id = @id

SET NOCOUNT OFF
END
