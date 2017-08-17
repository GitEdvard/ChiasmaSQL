USE [BookKeeping_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdateOrderSummary]    Script Date: 11/20/2009 16:10:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[p_UpdateOrderSummary](
@id INTEGER,
@comment varchar(1024),
@authority_id_orderer int = null,
@order_date datetime = null,
@authority_id_order_conf int = null,
@order_conf_date datetime = null,
@purchase_order_no varchar(255) = null,
@sales_order_no varchar(255) = null,
@place_of_purchase varchar(20) = null,
@freight_cost money = null,
@customer_number_id int = null,
@invoice_status varchar(20),
@invoice_absent bit,
@currency_id int = null,
@invoice_check_date datetime = null,
@arrival_conf_date datetime = null,
@authority_id_invoice_check int = null
)
 
AS
BEGIN
SET NOCOUNT ON

declare @place_of_purchase_id int

select @place_of_purchase_id = place_of_purchase_id from place_of_purchase 
where code = @place_of_purchase

UPDATE order_summary
SET 
	comment = @comment,
	authority_id_orderer = @authority_id_orderer,
	order_date = @order_date,
	authority_id_order_conf = @authority_id_order_conf,
	order_conf_date = @order_conf_date,
	purchase_order_no = @purchase_order_no,
	sales_order_no = @sales_order_no,
	place_of_purchase_id = @place_of_purchase_id,
	freight_cost = @freight_cost,
	customer_number_id = @customer_number_id,
	invoice_status = @invoice_status,
	invoice_absent = @invoice_absent,
	currency_id = @currency_id,
	invoice_check_date = @invoice_check_date,
	arrival_conf_date = @arrival_conf_date,
	authority_id_invoice_check = @authority_id_invoice_check
WHERE order_summary_id = @id

IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update order summary with id: %s', 15, 1, @id)
	RETURN
END

SET NOCOUNT OFF
END
