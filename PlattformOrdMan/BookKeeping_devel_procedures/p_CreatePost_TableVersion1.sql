USE [BookKeeping_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreatePost]    Script Date: 11/20/2009 16:10:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_CreatePost_TableVersion1](
@article_number_id int = null,
@authority_id_booker INTEGER,
@comment VARCHAR(1024) = NULL,
@merchandise_id INTEGER,
@supplier_id INTEGER = NULL,
@amount VARCHAR(255) = NULL,
@appr_prize MONEY = NULL,
@currency_id INTEGER,
@invoice_inst BIT = NULL,
@invoice_clin BIT = NULL,
@invoice_absent BIT = NULL,
@invoice_number varchar(255) = null,
@final_prize money = null,
@delivery_deviation varchar(1024) = null,
@purchase_order_no varchar(255) = null,
@sales_order_no varchar(255) = null,
@place_of_purchase varchar(30),
@customer_number_id int = null)

AS
BEGIN
SET NOCOUNT ON

DECLARE @post_id INTEGER
declare @place_of_purchase_id int

select @place_of_purchase_id = place_of_purchase_id 
from place_of_purchase 
where code = @place_of_purchase

INSERT INTO post_table_version_1
	(
		article_number_id,
		comment,
		authority_id_booker,
		book_date,
		merchandise_id,
		supplier_id,
		appr_prize,
		amount,
		currency_id,
		invoice_inst,
		invoice_clin,
		invoice_absent,
		invoice_number,
		final_prize,
		delivery_deviation,
		purchase_order_no,
		sales_order_no,
		place_of_purchase_id,
		customer_number_id
	)
VALUES
	(
		@article_number_id,
		@comment,
		@authority_id_booker,
		GETDATE(),
		@merchandise_id,
		@supplier_id,
		@appr_prize,
		@amount,
		@currency_id,
		@invoice_inst,
		@invoice_clin,
		@invoice_absent,
		@invoice_number,
		@final_prize,
		@delivery_deviation,
		@purchase_order_no,
		@sales_order_no,
		@place_of_purchase_id,
		@customer_number_id
	)

IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to create order post', 15, 1)
	RETURN
END

select * from post_table_version_1_view
WHERE id = SCOPE_IDENTITY()

SET NOCOUNT OFF
END
