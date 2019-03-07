SET VERIFY OFF
conn /as sysdba
set echo on
spool /opt/oracle/crdb/cr_pdbdev.log append
select  'database_running' from dual;
host mkdir -p /opt/oracle/oradata/cdbdev/pdbdev;
CREATE PLUGGABLE DATABASE pdbdev ADMIN USER pdbadmin IDENTIFIED BY "oracle" ROLES=(DBA) DEFAULT TABLESPACE users DATAFILE SIZE 10m AUTOEXTEND ON NEXT 8192k file_name_convert=('/opt/oracle/oradata/cdbdev/pdbseed',
'/opt/oracle/oradata/cdbdev/pdbdev');
alter pluggable database pdbdev open;
alter system register;
