SET VERIFY OFF
conn /as sysdba
set echo on
spool /opt/oracle/crdb/CreateDBCatalog.log append
alter session set "_oracle_script"=true;
alter pluggable database pdb$seed close;
alter pluggable database pdb$seed open;
host perl /opt/oracle/product/12.1.0.2/dbhome_1/rdbms/admin/catcon.pl -n 1 -l /opt/oracle/crdb -b catalog /opt/oracle/product/12.1.0.2/dbhome_1/rdbms/admin/catalog.sql;
host perl /opt/oracle/product/12.1.0.2/dbhome_1/rdbms/admin/catcon.pl -n 1 -l /opt/oracle/crdb -b catproc /opt/oracle/product/12.1.0.2/dbhome_1/rdbms/admin/catproc.sql;
host perl /opt/oracle/product/12.1.0.2/dbhome_1/rdbms/admin/catcon.pl -n 1 -l /opt/oracle/crdb -b catoctk /opt/oracle/product/12.1.0.2/dbhome_1/rdbms/admin/catoctk.sql;
host perl /opt/oracle/product/12.1.0.2/dbhome_1/rdbms/admin/catcon.pl -n 1 -l /opt/oracle/crdb -b owminst /opt/oracle/product/12.1.0.2/dbhome_1/rdbms/admin/owminst.plb;
host perl /opt/oracle/product/12.1.0.2/dbhome_1/rdbms/admin/catcon.pl -n 1 -l /opt/oracle/crdb -b pupbld -u SYSTEM/oracle /opt/oracle/product/12.1.0.2/dbhome_1/sqlplus/admin/pupbld.sql;
conn system/oracle
set echo on
spool /opt/oracle/crdb/sqlPlusHelp.log append
host perl /opt/oracle/product/12.1.0.2/dbhome_1/rdbms/admin/catcon.pl -n 1 -l /opt/oracle/crdb -b hlpbld -u SYSTEM/oracle -a 1  /opt/oracle/product/12.1.0.2/dbhome_1/sqlplus/admin/help/hlpbld.sql 1helpus.sql;
spool off
spool off
