SET VERIFY OFF
conn /as sysdba
set echo on
spool /opt/oracle/crdb/plugDatabase.log append
select  'database_running' from dual;
host mkdir -p /opt/oracle/oradata/dddcdb/dns;
CREATE PLUGGABLE DATABASE dns ADMIN USER dns IDENTIFIED BY "banana" ROLES=(DBA)  file_name_convert=('/opt/oracle/oradata/dddcdb/pdbseed',
'/opt/oracle/oradata/dddcdb/dns');
alter pluggable database dns open;
alter system register;
