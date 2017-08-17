use Auxilliary
go

SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

alter procedure p_ListOrphanCandidates(
	@db_name varchar(255)
)
as 
begin

	---------------------------------------------------------------
	-- Declare variables and tables
	---------------------------------------------------------------
	declare @directory_contents table(
	file_name varchar(512),
	depth int,
	isfile int)


	insert into @directory_contents
	exec Auxilliary.dbo.p_ListDirectory @db_name = @db_name

	create table #orphanCandidate(
	file_name varchar(512),
	id int,
	type varchar(255))

	declare @underscore varchar(1)
	set @underscore = '_'


	---------------------------------------------------------------
	-- List file names in bulk directory
	-- Patterns for file names:
	-- GenotypesForInternalReport_<db-id>.txt, or
	-- GenotypesForResultPlate_<db-id>.txt
	-- Extract type, (internal report or result plate)
	-- Extract db-id
	---------------------------------------------------------------

	insert into #orphanCandidate
	select file_name, 
	substring(file_name, charindex(@underscore, file_name) + 1, charindex('.txt', file_name) - charindex(@underscore, file_name) - 1),
	case when (charindex('InternalReport', file_name) > 0) 
		then 'InternalReport' 
		else  
			case when (charindex('ResultPlate', file_name) > 0)
			then 'ResultPlate'
			else 'Other' 
		end
	end
	from @directory_contents
	where isfile = 1


	-- Prepare OrphanBulkFile table, delete old entries, if any
	delete from Auxilliary.dbo.OrphanBulkFile where db_name = @db_name

	---------------------------------------------------------------
	-- Identify which of the internal reports/result plates that are orphan
	-- i.e. the corresponding id does not exists in db
	-- Place them in the delete table, to be read by a powershell script file to be deleted
	---------------------------------------------------------------
	declare @command varchar(max)

	set @command = '
	insert into Auxilliary.dbo.OrphanBulkFile
	select oc.file_name, ''' + @db_name + ''' from #orphanCandidate oc
	left outer join ' + @db_name + '.dbo.internal_report ir on ir.internal_report_id = oc.id
	where oc.type = ''InternalReport'' and
	oc.id > 0 and
	ir.internal_report_id is null
	union
	select oc.file_name, ''' + @db_name + ''' from #orphanCandidate oc
	left outer join ' + @db_name + '.dbo.result_plate rp on rp.result_plate_id = oc.id
	where oc.type = ''ResultPlate'' and
	oc.id > 0 and
	rp.result_plate_id is null
	'

	exec(@command)

	drop table #orphanCandidate

	SET NOCOUNT off
end
go
