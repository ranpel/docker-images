SET VERIFY OFF
conn /as sysdba
set echo on
spool /opt/oracle/crdb/CreateClustDBViews.log append
host perl /opt/oracle/product/12.1.0.2/dbhome_1/rdbms/admin/catcon.pl -n 1 -l /opt/oracle/crdb -b catclust /opt/oracle/product/12.1.0.2/dbhome_1/rdbms/admin/catclust.sql;
spool off
conn /as sysdba
set echo on
spool /opt/oracle/crdb/postDBCreation.log append
grant sysdg to sysdg;
grant sysbackup to sysbackup;
grant syskm to syskm;
