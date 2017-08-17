USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_OrderManTransferUserBarcodes]    Script Date: 11/16/2009 13:33:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_OrderManTransferUserBarcodes](
	@targ_db1 varchar(20) = null,
	@targ_db2 varchar(20) = null
)

AS
BEGIN
SET NOCOUNT ON

declare @cmd varchar(1024)

create table #chiasma_barcode(
server_login varchar(255),
barcode varchar(255)
)

insert into #chiasma_barcode
(server_login, barcode)
select	a.identifier, ib.code
from	authority a
		inner join internal_barcode ib
			on ib.identifiable_id = a.authority_id
		inner join kind k
			on k.kind_id = ib.kind_id
where	k.name = 'authority'

if len(isnull(@targ_db1, '')) > 0
begin
	set @cmd = 'use ' + @targ_db1 +
	' update	authority
	set		chiasma_barcode = cb.barcode 
	from	#chiasma_barcode cb 
	where	cb.server_login = identifier 
			and 
			not isnull(chiasma_barcode, '''') = cb.barcode'

	exec (@cmd)
end

if len(isnull(@targ_db2, '')) > 0
begin
	set @cmd = 'use ' + @targ_db2 +
	' update	authority
	set		chiasma_barcode = cb.barcode 
	from	#chiasma_barcode cb 
	where	cb.server_login = identifier 
			and 
			not isnull(chiasma_barcode, '''') = cb.barcode'

	exec (@cmd)
end


SET NOCOUNT OFF
END
