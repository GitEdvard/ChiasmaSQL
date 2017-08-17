USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_DeleteBeadChipType]    Script Date: 11/20/2009 15:46:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_DeleteBeadChipType](@id INTEGER)

AS
BEGIN
SET NOCOUNT ON

declare @references integer
declare @identifier varchar(255);


with chip_count as (
select bead_chip_id as chip_id, identifier from bead_chip where bead_chip_type_id = @id
union
select flow_cell_id as chip_id, identifier from flow_cell where bead_chip_type_id = @id)
select @references = count(chip_id) from chip_count

select @identifier = identifier from bead_chip_type where bead_chip_type_id = @id

IF @references > 0
BEGIN
	RAISERROR('The selected chip design is referenced by a BeadChip or a Flowcell, deletion canceled: %s', 15, 1, @identifier)
	RETURN
END


DELETE FROM bead_chip_label where bead_chip_type_id = @id

DELETE FROM bead_chip_type where bead_chip_type_id = @id

SET NOCOUNT OFF
END
