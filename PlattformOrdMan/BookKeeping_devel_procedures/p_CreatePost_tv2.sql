USE [BookKeeping_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreatePost_tv2]    Script Date: 11/20/2009 16:10:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[p_CreatePost_tv2](
	@article_number_id int = null,
	@comment varchar(1024) = null,
	@authority_id_booker int,
	@book_date datetime,
	@merchandise_id int,
	@supplier_id int = null,
	@predicted_arrival datetime = null,
	@amount int = null,
	@currency_id int = null,
	@final_prize money = null,
	@delivery_deviation varchar(1024) = null,
	@order_summary_id int = null,
	@appr_prize money = null,
	@place_of_purchase varchar(20)
)

AS
BEGIN
SET NOCOUNT ON

declare @place_of_purchase_id int

select @place_of_purchase_id = place_of_purchase_id from place_of_purchase
where code = @place_of_purchase

INSERT INTO post_table_version_2
(
	article_number_id,
	comment,
	authority_id_booker,
	book_date,
	merchandise_id,
	supplier_id,
	predicted_arrival,
	amount,
	currency_id,
	final_prize,
	delivery_deviation,
	order_summary_id,
	place_of_purchase_id,
	appr_prize
)
VALUES
(
	@article_number_id,
	@comment,
	@authority_id_booker,
	@book_date,
	@merchandise_id,
	@supplier_id,
	@predicted_arrival,
	@amount,
	@currency_id,
	@final_prize,
	@delivery_deviation,
	@order_summary_id,
	@place_of_purchase_id,
	@appr_prize
)
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to create post (table version 2):', 15, 1)
	RETURN
END

SELECT * from post_table_version_2_view
WHERE id = scope_identity()

SET NOCOUNT OFF
END
