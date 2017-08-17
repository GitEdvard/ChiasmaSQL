USE [bookkeeping_devel]
GO

/****** Object:  StoredProcedure [dbo].[p_ConfirmPostOrdered_tv1]    Script Date: 2014-02-21 16:01:02 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO






CREATE PROCEDURE [dbo].[p_ConfirmPostOrdered_tv1](
@id INTEGER,
@authority_id_confirmed_order INTEGER)

AS
BEGIN
SET NOCOUNT ON

UPDATE post_table_version_1
SET 
	authority_id_confirmed_order = @authority_id_confirmed_order,
	confirmed_order_date = GETDATE()
WHERE post_id = @id
	
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update post with id:', 15, 1, @id)
	RETURN
END

SET NOCOUNT OFF
END





GO


