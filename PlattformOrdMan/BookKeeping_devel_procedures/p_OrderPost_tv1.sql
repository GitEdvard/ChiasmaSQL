USE [BookKeeping_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_OrderPost_tv1]    Script Date: 11/20/2009 16:10:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_OrderPost_tv1](
@id INTEGER,
@authority_id_orderer INTEGER)

AS
BEGIN
SET NOCOUNT ON

UPDATE post_table_version_1
SET 
	authority_id_orderer = @authority_id_orderer,
	order_date = GETDATE()
WHERE post_id = @id
	
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update post with id:', 15, 1, @id)
	RETURN
END

SET NOCOUNT OFF
END
