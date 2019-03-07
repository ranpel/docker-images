SET VERIFY OFF
conn /as sysdba
alter session set container=pdbdev;
set echo on
spool /opt/oracle/crdb/postPDBCreation.log append
alter user pdbadmin quota unlimited on users;
exec dbms_xdb_config.sethttpsport(5501);
alter session set container=cdb$root;
alter pluggable database pdbdev save state;
exit;
