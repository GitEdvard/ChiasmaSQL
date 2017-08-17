# ChiasmaSQL
A set of db-procedures and sql scripts related to the Chiasma system

## Administration project
A set of db-procedures to backup and restore the development database for the Chiasma project. Each 
developer is working against his personal development database. These procs give the option to reset 
the personal development database to the latest release, or the latest merge. 

There are procs for grant execute, and update application version.

There are procs to create new development users and logins

## Auxilliary_procedures
Contains FileToSelect, which reads a txt file and put contents in a temp table. 
p_ListDirectory, p_ListOrphanFiles, are used in scheduled tasks on mm-wchs001

## DBAMonitor
A set of procs that are used by scheduled tasks on mm-wchs001
