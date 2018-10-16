#!/bin/sh

OLD_UMASK=`umask`
umask 0027
mkdir -p /opt/oracle/oradata/fast_recovery_area/dddcdb
mkdir -p /opt/oracle/oradata/dddcdb/pdbseed
mkdir -p /opt/oracle/admin/dddcdb/adump
mkdir -p /opt/oracle/admin/dddcdb/dpdump
mkdir -p /opt/oracle/admin/dddcdb/pfile
mkdir -p /opt/oracle/audit
mkdir -p /opt/oracle/cfgtoollogs/dbca/dddcdb
mkdir -p /opt/oracle/product/12.1.0.2/dbhome_1/dbs
umask ${OLD_UMASK}
PERL5LIB=$ORACLE_HOME/rdbms/admin:$PERL5LIB; export PERL5LIB
ORACLE_SID=dddcdb; export ORACLE_SID
PATH=$ORACLE_HOME/bin:$ORACLE_HOME/perl/bin:$PATH; export PATH
/opt/oracle/product/12.1.0.2/dbhome_1/bin/sqlplus /nolog @/opt/oracle/crdb/dddcdb.sql
