
use BookKeeping_devel
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW merchandise_plain_view AS
SELECT 
	m.merchandise_id AS id,
	m.identifier,
	m.supplier_id,
	m.enabled,
	m.comment,
	m.amount,
	m.appr_prize,
	m.storage,
	m.category,
	m.invoice_category_id,
	m.currency_id
FROM merchandise m 
