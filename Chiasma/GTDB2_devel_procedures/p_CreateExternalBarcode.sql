USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreateExternalBarcode]    Script Date: 11/16/2009 13:36:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_CreateExternalBarcode] (
	@barcode VARCHAR(255),
	@identifiable_id INTEGER = NULL,
	@kind VARCHAR(32) = NULL)

AS
BEGIN
SET NOCOUNT ON

-- Get kind id.
DECLARE @kind_id INTEGER
SET @kind_id = NULL
IF @kind IS NOT NULL
BEGIN
	SELECT @kind_id = kind_id FROM kind WHERE name = @kind
	IF @kind IS NULL
	BEGIN
		RAISERROR('Failed to create bar code with code: %s', 15, 1, @barcode)
		RETURN
	END
END

-- Create bar code.
INSERT INTO external_barcode (code, identifiable_id, kind_id)
VALUES (@barcode, @identifiable_id, @kind_id);
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to create bar code with code: %s', 15, 1, @barcode)
	RETURN
END

SET NOCOUNT OFF
END
