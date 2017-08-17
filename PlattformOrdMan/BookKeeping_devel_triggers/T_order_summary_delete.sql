--USE [BookKeeping_devel]
--GO
/****** Object:  Trigger [dbo].[T_aliquot_insert_update]    Script Date: 11/20/2009 15:07:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Logs insert and update operations to the aliquot table.


ALTER TRIGGER [dbo].[T_order_summary_delete] ON [dbo].[order_summary]
AFTER DELETE

AS
BEGIN
SET NOCOUNT ON
 

INSERT INTO order_summary_history
(
	order_summary_id,
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
	invoice_status,
	invoice_absent,
	currency_id,
	authority_id_creator,
	created_date,
	invoice_check_date,
	arrival_conf_date,
	authority_id_invoice_check,
	changed_action
)
SELECT
	order_summary_id,
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
	invoice_status,
	invoice_absent,
	currency_id,
	authority_id_creator,
	created_date,
	invoice_check_date,
	arrival_conf_date,
	authority_id_invoice_check,
    'D'
FROM deleted
	
SET NOCOUNT OFF
END
