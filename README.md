# c# db workflow
A set of db-procedures and sql scripts related to development of databases in MicroSoft Server

## Administration project
Each developer is working against his personal development database. These procs give the option to reset 
the personal development database to the latest release, or the latest merge. 

There are procs for grant execute, and update application version.

There are procs to create new development users and logins

## Auxilliary_procedures
Contains FileToSelect, which reads a txt file and put contents in a temp table. 
p_ListDirectory, p_ListOrphanFiles, are used in scheduled tasks on mm-wchs001

## DBAMonitor
A set of procs that are used by scheduled tasks on mm-wchs001


## Workflow description
Here are some procedures to handle development databases for some applications,
(Chiasma, SQAT, Order, Projman)
The following database structure is anticipated:

		       Operational database (eg. GTDB2)
				| 
		       Testing database (staging, or practice) (eg. GTDB2_practice)
			        |
		       Development database (eg. GTDB2_devel)
				| 
		       Personal development database (e.g. GTDB2_devel_ee)

The set of procedures facilitate for the developer to have this workflow
1. Developer play around on his or her personal development database
2. Developer realize that the changes he made was not adequate, and fetch the 
   latest (common) devel database, from one level up, then starts over
3. Developer is satisfied with changes on his personal database, and push changes up one level
   (This particular step is done by a tailored db script, not by procedures in this repo)

The procedures helps with two things
* As described above, to give the option to reset changes
* To keep away the large amount of junk data that is produced during development. 

Therefore, at development database level, it should only exist relevant and instructive 
data! That means no junk data! 

All databases included by this workflow are matched by an client application written in C#. 
These c# applications has an database connection string adapted for either development, 
testing or operational. The default setting is to connect to a personal development database. Deploying
of new releases are done by the python app release-ccharp, where the connection string is updated to connect
to either the test or operational database. 

Procedures without a "p_admin_" prefix is intended for a devel user to run during the development 
workflow (eg. devel_edvard). Note the importance to use a devel user during development, to prevent updating an
operational database by mistake. Therefore, I suggest that the admin user should not have access to the 
development procedures. 

-------
Add new database to the workflow
-------
* manually create a new personal database
* Add entry in table map_devel_table
* Manually create a backup of devel database
  > backup database ProjectMan_devel to disk = 'D:\Proc_references\Devel_backups\Latest release\projectman_devel_backup.bak' with init, skip
* create procedure p_admin_Clone_XXX_DevelLatestRelease, where XXX is the new database
* Make sure that there is a user in the devel database that's connected to your devel-user login. This user should be database owner for the devel database
  > example: GTDB2_devel has a user User_devel_edvard, which is connected to the login "devel_edvard". User_devel_edvard is db-owner for GTDB2_devel
* run the procedure at server (user has to have ALL permissions)
* After adding a db-procedure to administration (not a "p_admin_" proc), run procedure p_admin_GrantExecuteThis. This 
  gives the devel_user permission to run the new proc



