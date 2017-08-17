USE [GTDB2_devel]
GO
/****** Object:  Trigger [dbo].[T_external_barcode_insert]    Script Date: 11/20/2009 15:10:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--MAKE SURE THAT
--* THE SAME CODE CANNOT BE IN BOTH THE INTERNAL AND EXTERNAL BAR CODE TABLES.
--* THE SAME IDENTIFIABLE_ID CANNOT OCCUR MORE THAN ONCE IN THE UNION OF INTERNAL_BARCODE AND EXTERNAL_BARCODE.

CREATE TRIGGER [dbo].[T_external_barcode_insert] ON [dbo].[external_barcode]
AFTER INSERT

AS
BEGIN
	SET NOCOUNT ON
	
	IF EXISTS (SELECT * FROM internal_barcode ib, external_barcode eb WHERE ib.code = eb.code)
	BEGIN
		RAISERROR('Cannot create identical internal and external bar codes.', 15, 1)
		RETURN		
	END

	IF EXISTS (SELECT COUNT(*) FROM barcode WHERE NOT identifiable_id IS NULL GROUP BY identifiable_id, kind_id HAVING COUNT(*)>1)
	BEGIN
		RAISERROR('The same item cannot have more than one bar code.', 15, 1)
		RETURN			
	END

	SET NOCOUNT OFF
END
