
use BookKeeping_devel
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW post_table_version_2_view AS
SELECT 
	p.post_id as id,
	p.article_number_id,
	p.comment,
	p.authority_id_booker,
	p.book_date,
	p.merchandise_id,
	p.predicted_arrival,
	p.arrival_date,
	p.arrival_sign,
	p.amount,
	p.currency_id,
	p.final_prize,
	p.delivery_deviation,
	p.order_summary_id,
	p.invoice_id,
	p.supplier_id,
	p.appr_prize,
	pop.code as place_of_purchase,
	an.identifier as article_number_identifier,
	an.active as article_number_active,
	an.merchandise_id as article_number_merchandise_id,
	m.identifier as merchandise_identifier,
	m.amount as merchandise_amount,
	m.enabled as merchandise_enabled,
	m.appr_prize as merchandise_appr_prize,
	m.comment as merchandise_comment,
	s.identifier as supplier_identifier,
	os.authority_id_orderer,
	os.order_date,
	os.authority_id_order_conf as authority_id_confirmed_order,
	os.order_conf_date as confirmed_order_date,
	os.invoice_absent,
	os.sales_order_no,
	os.purchase_order_no,
	i.authority_id_checker as authority_id_invoicer,
	i.check_date as invoice_date,
	i.identifier as invoice_number,
	i.status as invoice_status,
	ic.number as invoice_category_number
FROM post_table_version_2 p
	INNER JOIN place_of_purchase pop on pop.place_of_purchase_id = p.place_of_purchase_id
	LEFT OUTER JOIN article_number an on an.article_number_id = p.article_number_id
	LEFT OUTER JOIN merchandise m on m.merchandise_id = p.merchandise_id
	LEFT OUTER JOIN supplier s on s.supplier_id = p.supplier_id
	LEFT OUTER JOIN order_summary os on os.order_summary_id = p.order_summary_id
	LEFT OUTER JOIN invoice i on i.invoice_id = p.invoice_id
	LEFT OUTER JOIN invoice_category ic on ic.invoice_category_id = m.invoice_category_id

