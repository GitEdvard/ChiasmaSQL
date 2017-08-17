USE [GTDB2_devel]
GO
/****** Object:  View [dbo].[denorm_genotype]    Script Date: 11/20/2009 13:56:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[denorm_genotype]

AS

SELECT
g.genotype_id as genotype_id,
s.sample_id AS sample_id,
s.identifier AS sample,
i.individual_id as individual_id,
i.identifier as individual,
a.assay_id as assay_id,
a.identifier AS assay,
m.marker_id as marker_id,
m.identifier AS marker,
dbo.fTopPolarizeAlleleResult(g.allele_result_id, g.assay_id) AS alleles,
dbo.fTopPolarizeAlleleVariant(a.assay_id) as allele_variant,
sc.name as status,
rp.result_plate_id AS result_plate_id,
rp.identifier AS result_plate,
g.locked_wset_id AS locked_wset_id

FROM genotype g
	INNER JOIN sample s ON s.sample_id = g.sample_id
		INNER JOIN individual i ON i.individual_id = s.individual_id
	INNER JOIN assay a ON a.assay_id = g.assay_id
		INNER JOIN marker m ON m.marker_id = a.marker_id
	INNER JOIN status_code sc ON sc.status_id = g.status_id
	INNER JOIN result_plate rp ON rp.result_plate_id = g.result_plate_id

