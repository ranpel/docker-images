SET VERIFY OFF
spool /opt/oracle/crdb/postDBCreation.log append
host perl /opt/oracle/product/12.1.0.2/dbhome_1/rdbms/admin/catcon.pl -n 1 -l /opt/oracle/crdb -b catbundleapply /u01/app/oracle/product/12.1.0.2/dbhome_1/rdbms/admin/catbundleapply.sql;
conn /as sysdba
set echo on
create spfile FROM pfile='/opt/oracle/crdb/init.ora';
conn /as sysdba
host perl /opt/oracle/product/12.1.0.2/dbhome_1/rdbms/admin/catcon.pl -n 1 -l /opt/oracle/crdb -b utlrp /opt/oracle/product/12.1.0.2/dbhome_1/rdbms/admin/utlrp.sql;
select comp_id, status from dba_registry;
create undo tablespace undo datafile '/opt/oracle/oradata/cdbdev/undo01.dbf' size 20M;
shutdown immediate;
conn /as sysdba
startup ;
conn /as sysdba
alter system switch logfile;
alter system set undo_tablespace=undo scope=spfile;
alter system switch logfile;
shutdown immediate;
conn /as sysdba
startup;
exec dbms_xdb_config.sethttpsport(5500);
drop tablespace undotbs1 including contents and datafiles;
spool off
