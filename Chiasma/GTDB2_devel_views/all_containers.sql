USE [GTDB2_devel]
GO
/****** Object:  View [dbo].[all_containers]    Script Date: 11/20/2009 13:54:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Test 

-- Tes t2
ALTER VIEW [dbo].[all_containers]
AS
SELECT     flow_cell.flow_cell_id AS generic_container_id, flow_cell.identifier AS identifier, container_type.container_type_id AS container_type_id, 
                      flow_cell.status AS status
FROM         flow_cell, container_type
WHERE     container_type.name = 'FlowCell'
UNION
SELECT     bead_chip.bead_chip_id AS generic_container_id, bead_chip.identifier AS identifier, container_type.container_type_id AS container_type_id, 
                      bead_chip.status AS status
FROM         bead_chip, container_type
WHERE     container_type.name = 'BeadChip'
UNION
SELECT     container.container_id AS generic_container_id, container.identifier AS identifier, container.container_type_id AS container_type_id, 
                      container.status AS status
FROM         container
UNION
SELECT     plate.plate_id AS generic_container_id, plate.identifier AS identifier, container_type.container_type_id AS container_type_id, 
                      plate.status AS status
FROM         plate, container_type
WHERE     container_type.name = 'Plate'
UNION
SELECT     tube.tube_id AS generic_container_id, tube.identifier AS identifier, container_type.container_type_id AS container_type_id, tube.status AS status
FROM         tube, container_type
WHERE     container_type.name = 'Tube'

UNION
SELECT		tr.tube_rack_id as generic_container_id, tr.identifier as identifier, ct.container_type_id as container_type_id, tr.status as status
FROM		tube_rack tr , container_type ct
WHERE		ct.name = 'TubeRack'

GO
--EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
--Begin DesignProperties = 
--   Begin PaneConfigurations = 
--      Begin PaneConfiguration = 0
--         NumPanes = 4
--         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
--      End
--      Begin PaneConfiguration = 1
--         NumPanes = 3
--         Configuration = "(H (1 [50] 4 [25] 3))"
--      End
--      Begin PaneConfiguration = 2
--         NumPanes = 3
--         Configuration = "(H (1 [50] 2 [25] 3))"
--      End
--      Begin PaneConfiguration = 3
--         NumPanes = 3
--         Configuration = "(H (4 [30] 2 [40] 3))"
--      End
--      Begin PaneConfiguration = 4
--         NumPanes = 2
--         Configuration = "(H (1 [56] 3))"
--      End
--      Begin PaneConfiguration = 5
--         NumPanes = 2
--         Configuration = "(H (2 [66] 3))"
--      End
--      Begin PaneConfiguration = 6
--         NumPanes = 2
--         Configuration = "(H (4 [50] 3))"
--      End
--      Begin PaneConfiguration = 7
--         NumPanes = 1
--         Configuration = "(V (3))"
--      End
--      Begin PaneConfiguration = 8
--         NumPanes = 3
--         Configuration = "(H (1[56] 4[18] 2) )"
--      End
--      Begin PaneConfiguration = 9
--         NumPanes = 2
--         Configuration = "(H (1 [75] 4))"
--      End
--      Begin PaneConfiguration = 10
--         NumPanes = 2
--         Configuration = "(H (1[66] 2) )"
--      End
--      Begin PaneConfiguration = 11
--         NumPanes = 2
--         Configuration = "(H (4 [60] 2))"
--      End
--      Begin PaneConfiguration = 12
--         NumPanes = 1
--         Configuration = "(H (1) )"
--      End
--      Begin PaneConfiguration = 13
--         NumPanes = 1
--         Configuration = "(V (4))"
--      End
--      Begin PaneConfiguration = 14
--         NumPanes = 1
--         Configuration = "(V (2))"
--      End
--      ActivePaneConfig = 0
--   End
--   Begin DiagramPane = 
--      Begin Origin = 
--         Top = 0
--         Left = 0
--      End
--      Begin Tables = 
--      End
--   End
--   Begin SQLPane = 
--   End
--   Begin DataPane = 
--      Begin ParameterDefaults = ""
--      End
--   End
--   Begin CriteriaPane = 
--      Begin ColumnWidths = 11
--         Column = 1440
--         Alias = 900
--         Table = 1170
--         Output = 720
--         Append = 1400
--         NewValue = 1170
--         SortType = 1350
--         SortOrder = 1410
--         GroupBy = 1350
--         Filter = 1350
--         Or = 1350
--         Or = 1350
--         Or = 1350
--      End
--   End
--End
--' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'all_containers'
--GO
--EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'all_containers'
