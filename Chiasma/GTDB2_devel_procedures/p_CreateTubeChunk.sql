USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreateTubeChunk]    Script Date: 11/20/2009 15:54:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
alter PROCEDURE [dbo].[p_CreateTubeChunk] (
	@code_length tinyint
)

AS
BEGIN
SET NOCOUNT ON

--*************************************************
-- CREATE TUBE-METADATA ENTRIES
--*************************************************
declare @first_metadata_id int
declare @last_expected_metadata_id int
declare @last_actually_created_meta_id int

set @first_metadata_id = IDENT_CURRENT('tube_metadata') + 1

-- Create as many entries in the tube-metadata table as number of tubes to be created
insert into tube_metadata
(tube_id)
select null from #CreateTubeTable

set @last_actually_created_meta_id = SCOPE_IDENTITY()

select @last_expected_metadata_id = max(internal_id) + @first_metadata_id from #CreateTubeTable

if not @last_actually_created_meta_id = @last_expected_metadata_id
begin
	raiserror('Identity mismatch in tube_metadata table', 15, 1)
	return
end


--*************************************************
-- CREATE TUBES
--*************************************************

-- #CreateSampleTable is created with a separate db-call
-- see DataServer class i client

declare @current_id int
declare @max_id int
declare @last_created_id int
declare @created_tubes table(tube_id int)

set @current_id = IDENT_CURRENT('generic_container') + 1

-- Create IDs by inserting rows in the generic_container table.
-- (as many as in the #CreateTubeTable)
INSERT INTO generic_container (generic_container_type) 
select 'Tube' from #CreateTubeTable 

select @last_created_id = SCOPE_IDENTITY()

insert into tube
(tube_id, identifier, tube_usage, method, is_failed, is_highlighted, tube_metadata_id)
output inserted.tube_id into @created_tubes
select @current_id + internal_id, identifier, tube_usage, method, is_failed, is_highlighted, @first_metadata_id + internal_id
from #CreateTubeTable

-- Update tube-metadata table with the proper tube-id values
update tube_metadata set
	tube_id = t.tube_id
from tube t 
inner join @created_tubes ct on t.tube_id = ct.tube_id
inner join tube_metadata tm on t.tube_metadata_id = tm.tube_metadata_id

select @max_id = (@current_id + max(internal_id)) from #CreateTubeTable

if not @max_id = @last_created_id
begin
	raiserror('Identity mismatch between generic_container table and tube table', 15,5)
	return
end

IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to creating tubes', 15, 1)
	RETURN
END

--*************************************************
-- CREATE BARCODES
--*************************************************
declare @first_barcode table(bc varchar(255))
declare @tmp_barcode table(bc varchar(255))
declare @barcode_table table(bc varchar(255), bc_int int, identifiable_id int)
declare @conflict_barcode_table table(identifiable_id int, rn int)
declare @first_barcode_int int
declare @counter int
declare @tmp_identifiable_id int

-- Find first available barcode
insert into @first_barcode
exec  p_CreateInternalBarcode @identifiable_id = @current_id , @kind = 'CONTAINER', @code_length = @code_length

-- Create a table of trial barcodes
-- Exclude first entry in #CreateTubeTable, barcode is already created for that item
select @first_barcode_int = cast(bc as int) from @first_barcode

insert into @barcode_table
(bc_int, identifiable_id)
select internal_id + @first_barcode_int, internal_id + @current_id 
	from #CreateTubeTable
	where not internal_id = 0


update @barcode_table set
	bc = dbo.fPadInternalBarcode(@code_length, bc_int)

-- Check if any trial barcode is existent in the external barcode table

insert into @conflict_barcode_table
(identifiable_id, rn)
select bct.identifiable_id, ROW_NUMBER() over (order by bct.identifiable_id)
from @barcode_table bct 
inner join external_barcode eb on bct.bc = eb.code

-- Create barcodes with no conflict in a bunch
insert into internal_barcode
(identifiable_id, code, kind_id)
select bt.identifiable_id, bt.bc, k.kind_id from @barcode_table bt, kind k
where k.name = 'container' and bt.identifiable_id not in 
(select identifiable_id from @conflict_barcode_table)


-- If conflicts with external barcodes, create internal barcode one and one with 
-- stored procedure
set @counter = 1
while exists (select * from @conflict_barcode_table where rn = @counter)
begin
	select @tmp_identifiable_id = identifiable_id from @conflict_barcode_table where rn = @counter
	insert into @tmp_barcode
	exec p_CreateInternalBarcode @identifiable_id = @tmp_identifiable_id, @kind = 'CONTAINER', @code_length = @code_length
	set @counter = @counter + 1
end


IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to create barcode for tubes', 15, 1)
	RETURN
END

select tv.* from tube_view tv
inner join #CreateTubeTable tt on tv.identifier = tt.identifier


SET NOCOUNT OFF
END


