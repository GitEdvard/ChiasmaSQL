use BookKeeping_devel
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW currency_view AS
SELECT 
	currency_id,
	symbol,
	identifier,
	currency_code
FROM currency
