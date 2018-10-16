SET VERIFY OFF
conn /as sysdba
set echo on
spool /opt/oracle/crdb/JServer.log append
host perl /opt/oracle/product/12.1.0.2/dbhome_1/rdbms/admin/catcon.pl -n 1 -l /opt/oracle/crdb -b initjvm /opt/oracle/product/12.1.0.2/dbhome_1/javavm/install/initjvm.sql;
host perl /opt/oracle/product/12.1.0.2/dbhome_1/rdbms/admin/catcon.pl -n 1 -l /opt/oracle/crdb -b initxml /opt/oracle/product/12.1.0.2/dbhome_1/xdk/admin/initxml.sql;
host perl /opt/oracle/product/12.1.0.2/dbhome_1/rdbms/admin/catcon.pl -n 1 -l /opt/oracle/crdb -b xmlja /opt/oracle/product/12.1.0.2/dbhome_1/xdk/admin/xmlja.sql;
host perl /opt/oracle/product/12.1.0.2/dbhome_1/rdbms/admin/catcon.pl -n 1 -l /opt/oracle/crdb -b catjava /opt/oracle/product/12.1.0.2/dbhome_1/rdbms/admin/catjava.sql;
conn /as sysdba
host perl /opt/oracle/product/12.1.0.2/dbhome_1/rdbms/admin/catcon.pl -n 1 -l /opt/oracle/crdb -b catxdbj /opt/oracle/product/12.1.0.2/dbhome_1/rdbms/admin/catxdbj.sql;
spool off
