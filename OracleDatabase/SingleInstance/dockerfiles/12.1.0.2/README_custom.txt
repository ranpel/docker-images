--- testing, testing one, two ---
Dyn DNS Dev - DDD (vs DDQ or DDP, QA, Prod)
Custom image setup kit

Download 12.1.0.2 linux database kit from Oracle and place in this directory
(linuxamd64_12102_database_1of2.zip)
(linuxamd64_12102_database_2of2.zip)

Build an image via the parent directory:
cd .. ; ./buildDockerImage.sh -v 12.1.0.2 -e

Deploy a database container:
cd 12.1.0.2
docker run -it --name dddcdb -p 11521:1521 -p 15500:5500 -p 15501:5501 -e ORACLE_SID=dddcdb -e ORACLE_PDB=dns -e ORACLE_PWD=oracle -e ORACLE_CHARACTERSET=AL32UTF8 oracle/database:12.1.0.2-ee

Validate and cut an image from container

------ pending -----
Final ORACLE_HOME cut and trim validation before commits - so far ≈ 1G trimmed from OH - not including pre and post build datafile grooming

