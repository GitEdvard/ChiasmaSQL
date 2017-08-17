use gtdb2_devel

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW plate_history_view AS
SELECT
	plate_id AS id,
	plate_usage,
	plate_type_id,
	identifier,
	status,
	comment,
	changed_date,
	changed_authority_id,
	changed_action,
	method
FROM plate_history
