
use BookKeeping_devel
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW invoice_view AS
SELECT 
	invoice_id as id,
	identifier,
	authority_id_checker,
	check_date,
	status,
	internal_identifier,
	order_summary_id
FROM invoice i
