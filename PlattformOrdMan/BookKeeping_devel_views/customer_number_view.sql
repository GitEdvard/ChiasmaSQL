use BookKeeping_devel
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW customer_number_view AS
SELECT 
	cn.customer_number_id as id,
	cn.identifier,
	cn.description,
	cn.supplier_id,
	pop.code as place_of_purchase,
	cn.enabled
from customer_number cn
	inner join place_of_purchase pop on cn.place_of_purchase_id = pop.place_of_purchase_id
