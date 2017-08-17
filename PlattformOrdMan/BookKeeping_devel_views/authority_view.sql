use BookKeeping_devel
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW authority_view AS
SELECT 
	a.authority_id AS id,
	a.identifier,
	a.name,
	a.account_status,
	a.user_type,
	pop.code as place_of_purchase,
	a.chiasma_barcode,
	a.comment
FROM authority a
INNER JOIN place_of_purchase pop on a.place_of_purchase_id = pop.place_of_purchase_id
