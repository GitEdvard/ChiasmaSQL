USE [GTDB2_devel]

GO
/****** Object:  View [dbo].[all_containers]    Script Date: 11/20/2009 13:54:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[date_search_view]
AS
select t.tube_id as generic_container_id, th.changed_date as created_date from tube t inner join
	tube_history th on t.tube_id = th.tube_id and th.changed_action = 'i'
union
select p.plate_id as generic_container_id, ph.changed_date as created_date from plate p inner join
	plate_history ph on p.plate_id = ph.plate_id and ph.changed_action = 'i'
union
select bc.bead_chip_id as generic_container_id, bch.changed_date as created_date from bead_chip bc inner join
	bead_chip_history bch on bc.bead_chip_id = bch.bead_chip_id and bch.changed_action = 'i'
union
select fc.flow_cell_id as generic_container_id, fch.changed_date as created_date from flow_cell fc inner join
	flow_cell_history fch on fc.flow_cell_id = fch.flow_cell_id and fch.changed_action = 'i'
