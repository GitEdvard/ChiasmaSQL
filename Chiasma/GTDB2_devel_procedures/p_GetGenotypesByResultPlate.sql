use GTDB2_devel
go
set ansi_nulls off
go
set quoted_identifier off
go
create procedure p_GetGenotypesByResultPlate(
	@id int
)
as 
begin
set nocount on 
	select
		genotype_id as id,
		result_plate_id, 
		sample_id, 
		assay_id, 
		status_id,
		allele_result_id,
		pos_x,
		pos_y,
		locked_wset_id
	from genotype
	where result_plate_id = @id

set nocount off
end
