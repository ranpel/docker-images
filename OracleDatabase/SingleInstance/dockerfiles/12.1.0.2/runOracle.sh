#!/bin/bash
# LICENSE UPL 1.0
#
# Copyright (c) 1982-2016 Oracle and/or its affiliates. All rights reserved.
# 
# Since: November, 2016
# Author: gerald.venzl@oracle.com
# Description: Runs the Oracle Database inside the container
# 
# DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS HEADER.
# 
# October 2019: Dev (crdbdev) - adjust to custom CREATE DATABASE requirement for option trimmed db

########### SIGINT handler ############
function _int() {
   echo "Stopping container."
   echo "SIGINT received, shutting down database!"
   sqlplus / as sysdba <<EOF
   shutdown immediate;
   exit;
EOF
   lsnrctl stop
}

########### SIGTERM handler ############
function _term() {
   echo "Stopping container."
   echo "SIGTERM received, shutting down database!"
   sqlplus / as sysdba <<EOF
   shutdown immediate;
   exit;
EOF
   lsnrctl stop
}

########### SIGKILL handler ############
function _kill() {
   echo "SIGKILL received, shutting down database!"
   sqlplus / as sysdba <<EOF
   shutdown abort;
   exit;
EOF
   lsnrctl stop
}

###################################
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! #
############# MAIN ################
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! #
###################################

# Check whether container has enough memory
# Github issue #219: Prevent integer overflow,
# only check if memory digits are less than 11 (single GB range and below) 
if [ `cat /sys/fs/cgroup/memory/memory.limit_in_bytes | wc -c` -lt 11 ]; then
   if [ `cat /sys/fs/cgroup/memory/memory.limit_in_bytes` -lt 2147483648 ]; then
      echo "Error: The container doesn't have enough memory allocated."
      echo "A database container needs at least 2 GB of memory."
      echo "You currently only have $((`cat /sys/fs/cgroup/memory/memory.limit_in_bytes`/1024/1024/1024)) GB allocated to the container."
      exit 1;
   fi;
fi;

# Set SIGINT handler
trap _int SIGINT

# Set SIGTERM handler
trap _term SIGTERM

# Set SIGKILL handler
trap _kill SIGKILL

# Default for ORACLE SID
if [ "$ORACLE_SID" == "" ]; then
   export ORACLE_SID=cdbdev
else
  # Make ORACLE_SID upper case
  # Github issue # 984
  # Reverthing this - something seems fishy
  #export ORACLE_SID=${ORACLE_SID^^}

  # Check whether SID is no longer than 12 bytes
  # Github issue #246: Cannot start OracleDB image
  if [ "${#ORACLE_SID}" -gt 12 ]; then
     echo "Error: The ORACLE_SID must only be up to 12 characters long."
     exit 1;
  fi;

  # Check whether SID is alphanumeric
  # Github issue #246: Cannot start OracleDB image
  if [[ "$ORACLE_SID" =~ [^a-zA-Z0-9] ]]; then
     echo "Error: The ORACLE_SID must be alphanumeric."
     exit 1;
   fi;
fi;

# Default for ORACLE PDB
export ORACLE_PDB=${ORACLE_PDB:-pdbdev}

# Make ORACLE_PDB upper case
# Github issue # 984
# Reverting this, too
#export ORACLE_PDB=${ORACLE_PDB^^}

# Default for ORACLE CHARACTERSET
export ORACLE_CHARACTERSET=${ORACLE_CHARACTERSET:-AL32UTF8}

# Check whether database already exists
if [ -f $ORACLE_BASE/.db_configured ]; then
  if [ -d $ORACLE_BASE/oradata/$ORACLE_SID ]; then
    # Start database
    $ORACLE_BASE/$START_FILE;
  else
    echo "Entered Start for existing database and failed to feel comfortable.  Cannot start database."
    echo "Opening shell to permit some investigation..  container will exit on exit."
    bash
    exit 2
  fi
else
  echo
  echo "Building database: $ORACLE_SID"
  echo
  # Create database
  # (cdbdev - this is now CREATE DATABASE custom crdb)
  $ORACLE_BASE/$CREATE_DB_FILE $ORACLE_SID $ORACLE_PDB $ORACLE_PWD;
   
  # Execute custom provided setup scripts
  # we don't have these yet but .. good to know, thx
  #$ORACLE_BASE/$USER_SCRIPTS_FILE $ORACLE_BASE/scripts/setup
fi;

# Check whether database is up and running
$ORACLE_BASE/$CHECK_DB_FILE
# but how about you let ma' node boot so I can maybe get in and fix it before a semi-blind image rebuild
if [ $? -eq 0 ]; then
  echo "#########################"
  echo "DATABASE IS READY TO USE!"
  echo "#########################"
  
  # Execute custom provided startup scripts
  #$ORACLE_BASE/$USER_SCRIPTS_FILE $ORACLE_BASE/scripts/startup
  
else
  echo "#####################################"
  echo "########### E R R O R ###############"
  echo "DATABASE SETUP WAS NOT SUCCESSFUL!"
  echo "Please check output for further info!"
  echo "########### E R R O R ###############" 
  echo "#####################################"
fi;

# Tail on alert log and wait (otherwise container will exit)
# watch case if we allow upper :( *highly* recommend going lower and sticking to it.)
# (cdbdev)
if [ -f "$ORACLE_BASE/.db_configured" ]; then
  echo
  echo "The following output is now a tail of the alert.log:"
  # This is just not doing it for me.. how about some beef with a bun and a pickle?
  if [ -f $ORACLE_BASE/diag/rdbms/${ORACLE_SID}/${ORACLE_SID}/trace/alert_${ORACLE_SID}.log ]; then
    tail -f $ORACLE_BASE/diag/rdbms/${ORACLE_SID}/${ORACLE_SID}/trace/alert_${ORACLE_SID}.log &
    childPID=$!
    wait $childPID
  else
    echo
    echo "Could not stat the database trace file.  Have a shell instead.."
    bash
    exit 0
  fi
else
  echo
  echo "No database configured file detected - check paths and sid case in diag dir."
  echo "  Connect and investigate..."
  echo
  echo "Starting bash to maybe jig a fix.  Container will exit on exit."
  bash
  exit 2
fi
