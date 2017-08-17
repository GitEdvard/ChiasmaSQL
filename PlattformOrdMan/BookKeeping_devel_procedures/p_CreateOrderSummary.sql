USE [BookKeeping_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreateOrderSummary]    Script Date: 11/20/2009 16:10:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[p_CreateOrderSummary](
	@comment varchar(1024) = null,
	@authority_id_orderer int = null,
	@order_date datetime = null,
	@autority_id_order_conf int = null,
	@order_conf_date datetime = null,
	@purchase_order_no varchar(255) = null,
	@sales_order_no varchar(255) = null,
	@place_of_purchase varchar(20),
	@freight_cost money = null,
	@customer_number_id int = null,
	@currency_id int = null
)
 
AS
BEGIN
SET NOCOUNT ON

declare @place_of_purchase_id int

select @place_of_purchase_id = place_of_purchase_id from place_of_purchase
where code = @place_of_purchase

INSERT INTO order_summary
(
	comment,
	authority_id_orderer,
	order_date,
	authority_id_order_conf,
	order_conf_date,
	purchase_order_no,
	sales_order_no,
	place_of_purchase_id,
	freight_cost,
	customer_number_id,
	currency_id
)
VALUES
(
	@comment,
	@authority_id_orderer,
	@order_date,
	@autority_id_order_conf,
	@order_conf_date,
	@purchase_order_no,
	@sales_order_no,
	@place_of_purchase_id,
	@freight_cost,
	@customer_number_id,
	@currency_id
)
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to create order summary:', 15, 1)
	RETURN
END

SELECT * from order_summary_view
WHERE id = scope_identity()

SET NOCOUNT OFF
END
