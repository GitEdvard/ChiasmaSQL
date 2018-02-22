use Auxilliary


go
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

alter procedure p_IdPanelStrandCheck
as
begin
SET NOCOUNT ON
create table #strandrefs (
	marker varchar(255),
	is_top_in_plus bit
)


bulk insert #strandrefs from 'D:\Proc_references\gtdb2_id_panel_check\id_panel_strand_refs.txt' 
with (
	fieldterminator = '\t',
	rowterminator = '\n'
)

if exists(select *
from #strandrefs tsf
inner join GTDB2.dbo.marker m on m.identifier = tsf.marker
inner join GTDB2.dbo.allele_variant_plus avp on m.marker_id = avp.marker_id
where not tsf.is_top_in_plus = avp.is_top_in_plus)
begin
	RAISERROR('Some of the strand referenses for id-panel markers have changed, and need to be investigated!', 15, 1)
end

SET NOCOUNT OFF
end
