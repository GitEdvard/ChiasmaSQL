use BookKeeping_devel
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW invoice_category_view AS
SELECT 
	invoice_category_id AS id,
	identifier,
	number
FROM invoice_category
