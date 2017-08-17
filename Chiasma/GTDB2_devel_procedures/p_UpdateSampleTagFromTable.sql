USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdateSampleTagFromTable]    Script Date: 11/20/2009 16:28:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[p_UpdateSampleTagFromTable](
	@update_index2 bit
)

-- A temp-table with name #SampleTagAssociationTable must exist and be prepared
AS
BEGIN
SET NOCOUNT ON

if isnull(@update_index2, 0) = 0
begin
	update sample set tag_index_id = sta.tag_index_id from sample s inner join 
	#SampleTagAssociationTable sta on s.sample_id = sta.sample_id
end
else
begin
	update sample set tag_index2_id = sta.tag_index_id from sample s inner join 
	#SampleTagAssociationTable sta on s.sample_id = sta.sample_id	
end

IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update samples', 15, 1)
	RETURN
END

SET NOCOUNT OFF
END
