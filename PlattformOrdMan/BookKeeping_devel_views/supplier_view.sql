
use BookKeeping_devel
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW supplier_view AS
SELECT 
	supplier_id as id,
	identifier,
	enabled,
	comment,
	tel_nr,
	contract_terminate,
	short_name
from supplier
