USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CheckMarkersInForward]    Script Date: 11/20/2009 15:54:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_CheckMarkersInForward](
@internal_report_id INTEGER
)

AS
BEGIN
SET NOCOUNT ON

select m.identifier from marker m inner join internal_report_marker_stat irms on
(m.marker_id = irms.marker_id) where irms.internal_report_id = @internal_report_id and
m.marker_id not in (select marker_id from allele_variant_forward)

SET NOCOUNT OFF
END
