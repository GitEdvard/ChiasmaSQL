use BookKeeping_devel
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW article_number_view AS
SELECT 
	article_number_id as id,
	identifier,
	merchandise_id,
	active
FROM article_number
