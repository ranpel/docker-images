SET VERIFY OFF
conn /as sysdba
alter session set container=dns;
set echo on
spool /opt/oracle/crdb/postPDBCreation.log append
CREATE BIGFILE TABLESPACE "USERS" LOGGING  DATAFILE  '/opt/oracle/oradata/dddcdb/dns/dns_users01.dbf' SIZE 10M REUSE AUTOEXTEND ON NEXT  1280K MAXSIZE UNLIMITED  EXTENT MANAGEMENT LOCAL  SEGMENT SPACE MANAGEMENT  AUTO;
ALTER DATABASE DEFAULT TABLESPACE "USERS";
exec dbms_xdb_config.sethttpsport(5501);
alter session set container=cdb$root;
alter pluggable database dns save state;
exit;
