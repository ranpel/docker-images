#!/bin/sh

OLD_UMASK=`umask`
umask 0027
mkdir -p /opt/oracle/oradata/fast_recovery_area/cdbdev
mkdir -p /opt/oracle/oradata/cdbdev/pdbseed
mkdir -p /opt/oracle/admin/cdbdev/adump
mkdir -p /opt/oracle/admin/cdbdev/dpdump
mkdir -p /opt/oracle/admin/cdbdev/pfile
mkdir -p /opt/oracle/audit
mkdir -p /opt/oracle/cfgtoollogs/dbca/cdbdev
mkdir -p /opt/oracle/product/12.1.0.2/dbhome_1/dbs
umask ${OLD_UMASK}
PERL5LIB=$ORACLE_HOME/rdbms/admin:$PERL5LIB; export PERL5LIB
ORACLE_SID=cdbdev; export ORACLE_SID
PATH=$ORACLE_HOME/bin:$ORACLE_HOME/perl/bin:$PATH; export PATH
/opt/oracle/product/12.1.0.2/dbhome_1/bin/sqlplus /nolog @/opt/oracle/crdb/cdbdev.sql
