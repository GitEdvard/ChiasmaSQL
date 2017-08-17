USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdateTubeAliquotTagFromTable]    Script Date: 11/20/2009 16:28:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[p_UpdateTubeAliquotTagFromTable](
@update_index2 bit
)

-- A temp-table with name #TubeAliquotTagAssociationTable must exist and be prepared
AS
BEGIN
SET NOCOUNT ON

if ISNULL(@update_index2, 0) = 0
begin
	update tube_aliquot set tag_index_id = tata.tag_index_id from tube_aliquot ta inner join 
	#TubeAliquotTagAssociationTable tata on ta.tube_aliquot_id = tata.tube_aliquot_id
end
else
begin
	update tube_aliquot set tag_index2_id = tata.tag_index_id from tube_aliquot ta inner join 
	#TubeAliquotTagAssociationTable tata on ta.tube_aliquot_id = tata.tube_aliquot_id
end

IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update tube-aliquots', 15, 1)
	RETURN
END

SET NOCOUNT OFF
END
