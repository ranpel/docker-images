set verify off
host /opt/oracle/product/12.1.0.2/dbhome_1/bin/orapwd file=/opt/oracle/product/12.1.0.2/dbhome_1/dbs/orapwdddcdb force=y format=12 entries=5 password=oracle
@/opt/oracle/crdb/CreateDB.sql
@/opt/oracle/crdb/CreateDBFiles.sql
@/opt/oracle/crdb/CreateDBCatalog.sql
@/opt/oracle/crdb/JServer.sql
@/opt/oracle/crdb/CreateClustDBViews.sql
@/opt/oracle/crdb/lockAccount.sql
@/opt/oracle/crdb/postDBCreation.sql
@/opt/oracle/crdb/PDBCreation.sql
@/opt/oracle/crdb/plug_dnspdb.sql
@/opt/oracle/crdb/postPDBCreation_dnspdb.sql
