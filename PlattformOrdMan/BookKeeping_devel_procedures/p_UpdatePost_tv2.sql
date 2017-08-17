USE [BookKeeping_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdatePost_tv2]    Script Date: 11/20/2009 16:10:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[p_UpdatePost_tv2](
	@id INTEGER,
	@article_number_id INTEGER = null,
	@comment VARCHAR(1024) = NULL,
	@authority_id_booker INTEGER,
	@book_date DATETIME,
	@supplier_id integer = null,
	@predicted_arrival datetime = NULL,
	@arrival_date DATETIME = NULL,
	@arrival_sign INTEGER = NULL,
	@amount VARCHAR(255) = NULL,
	@currency_id INTEGER,
	@final_prize money = null,
	@delivery_deviation varchar(1024) = null,
	@order_summary_id int = null,
	@appr_prize money = null,
	@place_of_purchase varchar(10)
)

AS
BEGIN
SET NOCOUNT ON


UPDATE post_table_version_2
SET 
	article_number_id = @article_number_id,
	comment = @comment,
	authority_id_booker = @authority_id_booker,
	book_date = @book_date,
	supplier_id = @supplier_id,
	predicted_arrival = @predicted_arrival,
	arrival_date = @arrival_date,
	arrival_sign = @arrival_sign,
	amount = @amount,
	currency_id = @currency_id,
	final_prize = @final_prize,
	delivery_deviation = @delivery_deviation,
	order_summary_id = @order_summary_id,
	place_of_purchase_id = pop.place_of_purchase_id,
	appr_prize = @appr_prize
FROM place_of_purchase pop 
WHERE post_id = @id and pop.code = @place_of_purchase
	
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update post with id:', 15, 1, @id)
	RETURN
END

SET NOCOUNT OFF
END
