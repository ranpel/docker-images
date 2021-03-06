SET VERIFY OFF
connect /as sysdba
set echo on
spool /opt/oracle/crdb/CreateDB.log append
startup nomount pfile="/opt/oracle/crdb/init.ora";
CREATE DATABASE "cdbdev"
USER SYS IDENTIFIED BY "oracle"
USER SYSTEM IDENTIFIED BY "oracle"
SET DEFAULT BIGFILE TABLESPACE
MAXINSTANCES 8
MAXLOGHISTORY 1
MAXLOGFILES 16
MAXLOGMEMBERS 3
MAXDATAFILES 1024
DATAFILE '/opt/oracle/oradata/cdbdev/system01.dbf' SIZE 600M REUSE AUTOEXTEND ON NEXT  10240K MAXSIZE 32G
EXTENT MANAGEMENT LOCAL
SYSAUX DATAFILE '/opt/oracle/oradata/cdbdev/sysaux01.dbf' SIZE 225M REUSE AUTOEXTEND ON NEXT  10240K MAXSIZE UNLIMITED
DEFAULT TEMPORARY TABLESPACE TEMP TEMPFILE '/opt/oracle/oradata/cdbdev/temp01.dbf' SIZE 20M REUSE AUTOEXTEND ON NEXT  640K MAXSIZE 32G
UNDO TABLESPACE "UNDOTBS1" DATAFILE  '/opt/oracle/oradata/cdbdev/undotbs01.dbf' SIZE 600M REUSE AUTOEXTEND ON NEXT  5120K MAXSIZE 32G
CHARACTER SET AL32UTF8
NATIONAL CHARACTER SET AL16UTF16
LOGFILE GROUP 1 ('/opt/oracle/oradata/cdbdev/redo01a.log','/opt/oracle/oradata/cdbdev/redo01b.log') SIZE 50M,
GROUP 2 ('/opt/oracle/oradata/cdbdev/redo02a.log','/opt/oracle/oradata/cdbdev/redo02b.log') SIZE 50M,
GROUP 3 ('/opt/oracle/oradata/cdbdev/redo03a.log','/opt/oracle/oradata/cdbdev/redo03b.log') SIZE 50M
enable pluggable database
seed file_name_convert=('/opt/oracle/oradata/cdbdev/system01.dbf','/opt/oracle/oradata/cdbdev/pdbseed/system01.dbf','/opt/oracle/oradata/cdbdev/sysaux01.dbf','/opt/oracle/oradata/cdbdev/pdbseed/sysaux01.dbf','/opt/oracle/oradata/cdbdev/temp01.dbf','/opt/oracle/oradata/cdbdev/pdbseed/temp01.dbf','/opt/oracle/oradata/cdbdev/undotbs01.dbf','/opt/oracle/oradata/cdbdev/pdbseed/undotbs01.dbf');
spool off
