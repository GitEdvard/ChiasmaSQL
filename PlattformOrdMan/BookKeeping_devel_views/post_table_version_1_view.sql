--USE [bookkeeping_devel]
--GO

/****** Object:  View [dbo].[post_view]    Script Date: 2014-02-21 14:48:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[post_table_version_1_view] AS
SELECT 
	p.post_id AS id,
	p.comment,
	p.authority_id_booker,
	p.book_date,
	p.merchandise_id,
	p.supplier_id,
	p.appr_prize,
	p.order_date,
	p.authority_id_orderer,
	p.predicted_arrival,
	p.invoice_inst,
	p.invoice_clin,
	p.arrival_date,
	p.arrival_sign,
	p.amount,
	p.invoice_status,
	p.authority_id_invoicer,
	p.invoice_date,
	p.invoice_absent,
	p.currency_id,
	p.article_number_id,
	p.invoice_number,
	p.final_prize,
	p.authority_id_confirmed_order,
	p.confirmed_order_date,
	p.delivery_deviation,
	p.purchase_order_no,
	p.sales_order_no,
	p.customer_number_id,
	pop.code as place_of_purchase,
	an.identifier as article_number_identifier,
	an.active as article_number_active,
	an.merchandise_id as article_number_merchandise_id,
	m.identifier as merchandise_identifier,
	m.amount as merchandise_amount,
	m.enabled as merchandise_enabled,
	m.comment as merchandise_comment,
	s.identifier as supplier_identifier,
	cn.description as customer_number_description,
	cn.identifier as customer_number_identifier,
	ic.number as invoice_category_number
FROM post_table_version_1 p
INNER JOIN place_of_purchase pop on p.place_of_purchase_id = pop.place_of_purchase_id
LEFT OUTER JOIN article_number an ON (an.article_number_id = p.article_number_id)
LEFT OUTER JOIN merchandise m on m.merchandise_id = p.merchandise_id
LEFT OUTER JOIN supplier s on s.supplier_id = p.supplier_id
LEFT OUTER JOIN customer_number cn on cn.customer_number_id = p.customer_number_id
LEFT OUTER JOIN invoice_category ic on m.invoice_category_id = ic.invoice_category_id


GO


