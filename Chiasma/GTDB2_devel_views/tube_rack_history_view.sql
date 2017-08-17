use gtdb2_devel

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW tube_rack_history_view AS
SELECT
	tube_rack_id as id,
	identifier,
	empty_slots,
	tube_rack_number,
	tube_rack_type_id,
	status,
	comment,
	changed_date,
	changed_authority_id,
	changed_action
FROM tube_rack_history
