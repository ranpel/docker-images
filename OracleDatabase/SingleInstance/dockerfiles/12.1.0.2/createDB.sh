#!/bin/bash
# LICENSE UPL 1.0
#
# Copyright (c) 1982-2016 Oracle and/or its affiliates. All rights reserved.
# 
# Since: November, 2016
# Author: gerald.venzl@oracle.com
# Description: Creates an Oracle Database based on following parameters:
#              $ORACLE_SID: The Oracle SID and CDB name
#              $ORACLE_PDB: The PDB name
#              $ORACLE_PWD: The Oracle password
# 
# DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS HEADER.
# 
# October, 2018: Dev (cdbdev) - Custom cr db limiting db extras

set -e

echo
echo "DEBUG -> $*"
echo

# Check whether ORACLE_SID is passed on
export ORACLE_SID=${1:-cdbdev}

# Check whether ORACLE_PDB is passed on
export ORACLE_PDB=${2:-pdbdev}

# Auto generate ORACLE PWD if not passed on
# interesting bash var ditty - vv - but this is dev, maybe loosen it up a little..
#export ORACLE_PWD=${3:-"`openssl rand -base64 8`1"}
export ORACLE_PWD=${3:-"oracle"}
echo
echo "ORACLE PASSWORD FOR SYS, SYSTEM AND PDBADMIN: $ORACLE_PWD";
echo

# If there is greater than 8 CPUs default back to dbca memory calculations
# dbca will automatically pick 40% of available memory for Oracle DB
# The minimum of 2G is for small environments to guarantee that Oracle has enough memory to function
# However, bigger environment can and should use more of the available memory
# This is due to Github Issue #307
#if [ `nproc` -gt 8 ]; then
#   sed -i -e 's|TOTALMEMORY = "2048"||g' $ORACLE_BASE/dbca.rsp
#fi;
# redirect mem and other db info option writes direct to crdb sql (or just define in stone)

# Create network related config files (sqlnet.ora, tnsnames.ora, listener.ora)
mkdir -p $ORACLE_HOME/network/admin
# sqlnet.ora: added beef
echo "NAME.DIRECTORY_PATH= (TNSNAMES, EZCONNECT, HOSTNAME)
SQLNET.INBOUND_CONNECT_TIMEOUT = 120
SQLNET.EXPIRE_TIME=10" > $ORACLE_HOME/network/admin/sqlnet.ora

# Listener.ora
echo "LISTENER = 
(DESCRIPTION_LIST = 
  (DESCRIPTION = 
    (ADDRESS = (PROTOCOL = IPC)(KEY = EXTPROC1)) 
    (ADDRESS = (PROTOCOL = TCP)(HOST = 0.0.0.0)(PORT = 1521)) 
  ) 
) 

DEDICATED_THROUGH_BROKER_LISTENER=ON
DIAG_ADR_ENABLED = off
" > $ORACLE_HOME/network/admin/listener.ora

# no cdb entry added? check if not then add - check.
echo "$ORACLE_SID= 
(DESCRIPTION = 
  (ADDRESS = (PROTOCOL = TCP)(HOST = 0.0.0.0)(PORT = 1521))
  (CONNECT_DATA =
    (SERVER = DEDICATED)
    (SERVICE_NAME = $ORACLE_SID)
  )
)
$ORACLE_PDB= 
(DESCRIPTION = 
  (ADDRESS = (PROTOCOL = TCP)(HOST = 0.0.0.0)(PORT = 1521))
  (CONNECT_DATA =
    (SERVER = DEDICATED)
    (SERVICE_NAME = $ORACLE_PDB)
  )
)" >> $ORACLE_HOME/network/admin/tnsnames.ora

# Start LISTENER and run crdb SQL
lsnrctl start &&

echo "Sleeping 5 ..."
sleep 5

# (cdbdev) cr db prereqs
# at present && testing ORACLE_SID hardcoded to cdbdev (mind case issues)

echo "Setting up for create cdb..."

if [ -f ${ORACLE_BASE}/crdb.tar ]; then
  pushd .
  cd $ORACLE_BASE
  tar xvf crdb.tar
else
  echo "ERROR: $0 Dev custom create database package not found.  Cannot continue."
  exit 1
fi

# enter build dir extracted from above - crdb logging is here too
cd $ORACLE_BASE/crdb
 
if [ ! -d ${ORACLE_HOME}/dbs ]; then
  mkdir -f ${ORACLE_HOME}/dbs
fi

echo "Entering create cdb..."
cd $ORACLE_BASE/crdb
./cdbdev.sh | tee -a $ORACLE_BASE/crdb/create_cdbdev.log

touch $ORACLE_BASE/.db_configured
# open perms on home to allow root entry into the container
chmod 755 $HOME
cd $ORACLE_HOME
rm -rf `cat $ORACLE_BASE/crdb/oh_trim`
