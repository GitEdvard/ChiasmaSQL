USE [BookKeeping_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdateMerchansise]    Script Date: 11/20/2009 16:10:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[p_UpdateMerchandise](
@id INTEGER,
@identifier VARCHAR(255),
@comment VARCHAR(1024),
@supplier_id INTEGER = NULL,
@amount VARCHAR(255),
@appr_prize MONEY,
@storage VARCHAR(255),
@article_number VARCHAR(255),
@enabled BIT,
@invoice_category_id INTEGER = NULL,
@currency_id INTEGER
)

AS
BEGIN
SET NOCOUNT ON

UPDATE merchandise SET
identifier = @identifier,
supplier_id = @supplier_id,
enabled = @enabled,
comment = @comment,
amount = @amount,
appr_prize = @appr_prize,
storage = @storage,
invoice_category_id = @invoice_category_id,
currency_id = @currency_id
WHERE merchandise_id = @id

IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to create merchandise with identifier: %s', 15, 1, @identifier)
	RETURN
END


IF NOT EXISTS(SELECT article_number_id FROM article_number WHERE merchandise_id = @id
AND identifier = @article_number)
BEGIN
	EXECUTE p_CreateArticleNumber @identifier = @article_number, @merchandise_id = @id
END

SET NOCOUNT OFF
END
