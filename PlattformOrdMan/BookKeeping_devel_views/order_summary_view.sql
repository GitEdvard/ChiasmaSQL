
use BookKeeping_devel
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
ALTER VIEW order_summary_view AS
SELECT 
	os.order_summary_id as id,
	os.comment,
	os.authority_id_orderer,
	os.order_date,
	os.authority_id_order_conf,
	os.order_conf_date,
	os.invoice_status,
	os.invoice_absent,
	os.currency_id,
	os.customer_number_id,
	os.authority_id_creator,
	os.created_date,
	os.invoice_check_date,
	os.arrival_conf_date,
	os.authority_id_invoice_check,
pop.code as place_of_purchase,
	os.sales_order_no,
	os.freight_cost,
	cn.description as customer_number_description,
	cn.identifier as customer_number_identifier
FROM order_summary os
INNER JOIN place_of_purchase pop on pop.place_of_purchase_id = os.place_of_purchase_id
LEFT OUTER JOIN customer_number cn ON (cn.customer_number_id = os.customer_number_id)
