# Oracle Database 12.1.0.2 Custom image setup kit results in cdb and pdb on board image

## Build custom image with database deployed
Download 12.1.0.2 linux database kit from Oracle and place into this directory (docker-images/OracleDatabase/SingleInstance/dockerfiles/12.1.0.2)
(linuxamd64_12102_database_1of2.zip)
(linuxamd64_12102_database_2of2.zip)

### Prepare any custom touches to the CREATE DATABASE scripts in the crdb directory
#### If you make changes to the create database scripts you must recreate the crdb.tar file
    tar cf crdb.tar crdb

### Build an image in the parent directory:
    cd .. ; ./buildDockerImage.sh -v 12.1.0.2 -e

### Deploy a database container:
This uses the base image built above and then deploys a container database.  Typically, this is where most Oracle DB images I've tested leave off thus requiring every new container that you spin up to build its own database.

    cd 12.1.0.2
    docker run -it --name mydb -p 11521:1521 -p 15500:5500 -p 15501:5501 -e ORACLE_SID=mycdb -e ORACLE_PDB=mypdb -e ORACLE_PWD=oracle -e ORACLE_CHARACTERSET=AL32UTF8 oracle/database:12.1.0.2-ee

### Validate and cut an image from container
This is your target image that will enable you to spin up containers with a database ready to be targeted.

    docker commit -a "your.email@somewhere.com" -m "12.1.0.2-ee + customPDB" imageID tag:version

### Fire a new database container

    docker run -it --name newdb -p 11521:1521 -p 15500:5500 -p 15501:5501 tag:version

*The port list includes the database listener port, dbcontrol for the cdb and dbcontrol for the pdb, if you so desired.*

*------ pending -----*
*Final ORACLE_HOME cut and trim validation before commit for new image - so far > 1G trimmed from OH - not including pre and post build datafile grooming*

