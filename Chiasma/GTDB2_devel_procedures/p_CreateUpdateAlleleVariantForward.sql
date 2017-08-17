USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreateUpdateAlleleVariantForward]    Script Date: 11/16/2009 13:36:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_CreateUpdateAlleleVariantForward](
	@marker_id INTEGER,
	@version VARCHAR(10),
	@allele_variant_id TINYINT,
	@is_top_in_forward BIT)
AS
BEGIN
SET NOCOUNT ON

-- Check if the same marker_id already exists in allele_variant_forward, 
-- if not add it to allele variant forward
if not exists(select avf.marker_id from allele_variant_forward avf where avf.marker_id = @marker_id)
	begin
		INSERT INTO allele_variant_forward
			(marker_id,
			 version,
			 allele_variant_id,
			 is_top_in_forward)
		VALUES
			(@marker_id,
			 @version,
			 @allele_variant_id,
			 @is_top_in_forward)		
	end
else
	begin
		declare @existingVersion varchar(10)
		declare @intVersion int
		declare @intExistingVersion int
		-- Check if this is a later version than existing 
		if isnumeric(@version) = 1
			select @intVersion = cast(@version as int)
		else
			set @intVersion = -1

		select @existingVersion = version from allele_variant_forward where marker_id = @marker_id
		if isnumeric(@existingVersion) = 1
			select @intExistingVersion = cast(@existingVersion as int)
		else
			set @intExistingVersion = -1

		
		if @intVersion > @intExistingVersion OR 
			not exists(select avf.marker_id from allele_variant_forward avf where 
				avf.allele_variant_id = @allele_variant_id)
			begin
				-- Check if this has two other alleles than existing 
				-- (not existing variant or its complement), and
				-- that this variant is not in allele_variant_forward_extra_version, 
				-- if not add it there
				if not exists(
							select avf.marker_id from allele_variant_forward avf inner join allele_variant av1 on
							avf.allele_variant_id = av1.allele_variant_id, allele_variant av2
							where avf.marker_id = @marker_id and av2.allele_variant_id = @allele_variant_id and
							((avf.is_top_in_forward = @is_top_in_forward and avf.allele_variant_id = @allele_variant_id) or
							(not avf.is_top_in_forward = @is_top_in_forward and av1.variant = av2.complement))
							)
					and
					not exists(
							select avfev.marker_id from allele_variant_forward_extra_version avfev inner join 
							allele_variant av1 on avfev.allele_variant_id = av1.allele_variant_id,
							allele_variant av2
							where avfev.marker_id = @marker_id and av2.allele_variant_id = @allele_variant_id and (
							(avfev.is_top_in_forward = @is_top_in_forward and avfev.allele_variant_id = @allele_variant_id) or
							(not avfev.is_top_in_forward = @is_top_in_forward and av1.variant = av2.complement)))
					begin
						insert into allele_variant_forward_extra_version
							(marker_id,
							 version,
							 allele_variant_id,
							 is_top_in_forward)
						values
							(@marker_id,
							 @version,
							 @allele_variant_id,
							 @is_top_in_forward)					
					end
				else
					begin
					-- Case when there is a later version and/or that the strand is swopped
					-- Add existing to old version and update existing avf
						insert into allele_variant_forward_old_version
							(marker_id, version, allele_variant_id, is_top_in_forward)
						select marker_id, version, allele_variant_id, is_top_in_forward from
							allele_variant_forward where marker_id = @marker_id
						
						update allele_variant_forward set
							version = @version,
							allele_variant_id = @allele_variant_id,	
							is_top_in_forward = @is_top_in_forward
						where marker_id = @marker_id
					end	
			end
	end

IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to create allele variant in forward notation: %s', 15, 1, @marker_id, @version)
	RETURN
END

SET NOCOUNT OFF
END


SET ANSI_NULLS ON
