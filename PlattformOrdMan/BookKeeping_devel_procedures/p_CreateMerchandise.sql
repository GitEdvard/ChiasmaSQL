USE [BookKeeping_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreateMerchansise]    Script Date: 11/20/2009 16:10:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[p_CreateMerchandise](
@identifier VARCHAR(255),
@comment VARCHAR(1024) = null,
@supplier_id INTEGER = NULL,
@amount VARCHAR(255),
@appr_prize MONEY,
@storage VARCHAR(255) = null,
@article_number VARCHAR(255) = NULL,
@category VARCHAR(255) = null,
@invoice_category_id INTEGER = NULL,
@currency_id INTEGER
)

AS
BEGIN
SET NOCOUNT ON

DECLARE @merchandise_id1 INTEGER

INSERT INTO merchandise
(identifier,
supplier_id,
comment,
amount,
appr_prize,
storage,
category,
invoice_category_id,
currency_id)
VALUES
(@identifier,
@supplier_id,
@comment,
@amount,
@appr_prize,
@storage,
@category,
@invoice_category_id,
@currency_id)

IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to create merchandise with identifier: %s', 15, 1, @identifier)
	RETURN
END

SET @merchandise_id1 = NULL
SELECT @merchandise_id1 = merchandise_id FROM merchandise WHERE identifier = @identifier
IF @merchandise_id1 IS NULL
BEGIN
	RAISERROR('merchandise_id for merchandise was not found', 15, 1)
	RETURN
END

IF @article_number = NULL
BEGIN
	SET @article_number = "";
END

if not @article_number = ""
begin
	EXECUTE p_CreateArticleNumberNoSelect @identifier = @article_number, @merchandise_id = @merchandise_id1
end

select * from merchandise_view 
WHERE id = @merchandise_id1

SET NOCOUNT OFF
END
