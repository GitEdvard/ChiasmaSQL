use gtdb2_devel

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW tube_history_view AS
SELECT
	tube_id AS id,
	tube_usage,
	identifier,
	status,
	comment,
	changed_date,
	changed_authority_id,
	changed_action,
	method,
	is_highlighted,
	is_failed
FROM tube_history
