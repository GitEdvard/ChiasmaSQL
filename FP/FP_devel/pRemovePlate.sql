
USE [FP_devel]
GO
/****** Object:  StoredProcedure [dbo].[pRemovePlate]    Script Date: 11/20/2009 16:48:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[pRemovePlate](@PlateNumber INTEGER)

-- SP TO REMOVE A PLATE FROM THE FP DATABASE, USING THE ID NUMBER
-- OF THE PLATE.

AS
BEGIN

	-- CHECKING IF THE PLATE EXITS
	IF NOT EXISTS(SELECT id FROM plate WHERE id = @PlateNumber)
	BEGIN
		RAISERROR('The plate number: %i does not exists', 15,
			1, @PlateNumber)
	END
	ELSE
	BEGIN
		-- STARTING BY REMOVING THE RUN THIS WILL CASCADE REMOVE THE
		-- DETECTION MODE AND THE DATA TABLES ENTRIES AS WELL
		
		BEGIN TRAN T1
		
		DELETE FROM run WHERE id IN (
			SELECT run_id FROM data WHERE plate_map_id IN (
			SELECT id FROM plate_map WHERE plate_id = @PlateNumber))
	
		IF @@Error <> 0
		BEGIN
			ROLLBACK TRAN T1
			RAISERROR('Error occured deleting the run, data, or detection_mode', 15, 1)	
		END
		ELSE
		BEGIN
			-- NEED TO DELETE THE SEGMENTS THIS WILL REMOVE THE 
			-- PLATE_MAP AS WELL.
		
			DELETE FROM segment WHERE id IN (
				SELECT segment_id FROM plate_map WHERE 
				plate_id =@PlateNumber)
			IF @@Error <> 0 
			BEGIN
				ROLLBACK TRAN T1
				RAISERROR('An error occured deleting segement or plate', 15, 1)
			END
			ELSE
			BEGIN
				
				-- DELETING THE PLATE_MAP IN CASE OF NO
				-- SEGMENTS ADDED
				
				DELETE FROM plate_map WHERE plate_id =
				@PlateNumber
				
				IF @@Error <> 0
				BEGIN
					ROLLBACK TRAN T1
					RAISERROR('Error occured deleting plate_map', 15, 1)
				END
				ELSE
				BEGIN
					-- DELETING THE PLATE ASWELL...
					DELETE FROM plate WHERE id = @PlateNumber
					IF @@Error <> 0 
					BEGIN
						ROLLBACK TRAN T1
						RAISERROR('Error occured deleting the plate ', 15, 1)
					END
					ELSE
					BEGIN
						COMMIT TRAN T1
					END
				END
			END
		
		END
	END
END
