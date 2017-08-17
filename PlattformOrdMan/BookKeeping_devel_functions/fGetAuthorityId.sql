USE [bookkeeping_devel]
GO
/****** Object:  UserDefinedFunction [dbo].[fGetAuthorityId]    Script Date: 11/20/2009 14:09:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[fGetAuthorityId]() RETURNS INTEGER
AS
BEGIN

	DECLARE @authority_id INTEGER 
	DECLARE @sys_user VARCHAR(255)
	DECLARE @spid INT

	SET @authority_id = -1
	SET @spid = @@spid

	-- User logged in i lab-mode (Chiasma and Order) cannot be identified by 
	-- SYSTEM_USER, so the table authority_session_mapping must be used.
	-- A system admin working from SQL Server Management Studio is not listed in the
	-- table authority_session_mapping, and is therefore identified through SYSTEM_USER

	-- In rare occurances, the table authority_session_mapping (a.s.m.) may not be updated when a 
	-- user logg off (not normal logouts), and the session-id for the 
	-- MSS Management Studio may then be the same as the inactive session_id 
	-- in the a.s.m. table. 
	-- 

	-- Check if authority is found in the authority_session_mapping table
	select	@authority_id = authority_id 
	from	authority_session_mapping 
	where	session_id = @spid

	IF @authority_id = -1
	BEGIN
		-- Authority not found in the authority_session_mapping table,
		-- find authority from sys-user instead
		SET @sys_user = SYSTEM_USER
		SELECT		@authority_id = authority_id 
		FROM		authority 
		WHERE		identifier = @sys_user

		-- IF THE ID IS NOT FOUND, TRY WITH THE DOMAIN NAME IN FRONT OF THE USER NAME.
		IF @authority_id = -1
		BEGIN
			SELECT		@authority_id = authority_id 
			FROM		authority 
			WHERE		identifier = 'USER\' + @sys_user
		END
	END
		
	IF @authority_id = -1
	BEGIN
		RETURN -100
	END

	RETURN @authority_id
END
