SET VERIFY OFF
conn /as sysdba
set echo on
spool /opt/oracle/crdb/plugDatabase.log append
select  'database_running' from dual;
spool /opt/oracle/crdb/plugDatabase.log append
startup ;
host mkdir -p /opt/oracle/oradata/dddcdb/dns;
select name from v$datafile  where con_id=2;
select name from v$tempfile where con_id =2;
CREATE PLUGGABLE DATABASE dns ADMIN USER dns IDENTIFIED BY "banana" ROLES=(DBA)  file_name_convert=('/opt/oracle/oradata/dddcdb/pdbseed',
'/opt/oracle/oradata/dddcdb/dns');
alter pluggable database dns open;
alter system register;
