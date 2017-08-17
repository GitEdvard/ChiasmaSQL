USE [bookkeeping_devel]
GO

/****** Object:  StoredProcedure [dbo].[p_CompletePost_tv1]    Script Date: 2014-02-21 15:56:17 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO






CREATE PROCEDURE [dbo].[p_CompletePost_tv1](
@id INTEGER,
@arrival_sign INTEGER)

AS
BEGIN
SET NOCOUNT ON

DECLARE @idString VARCHAR(15)
DECLARE @idStringTmp VARCHAR(15)
DECLARE @idStringLength INT

SET @idStringLength = 15

--Create identifier
SET @idStringTmp = CAST(@id AS VARCHAR(15))
SET @idString = REPLICATE('0', @idStringLength - LEN(@idStringTmp)) + @idStringTmp

UPDATE post_table_version_1
SET 
	arrival_sign = @arrival_sign,
	arrival_date = GETDATE()
WHERE post_id = @id
	
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update post with id:', 15, 1, @id)
	RETURN
END

SET NOCOUNT OFF
END





GO


