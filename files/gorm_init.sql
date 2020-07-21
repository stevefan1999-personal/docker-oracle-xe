-- creating user in the default PDB
ALTER SESSION SET CONTAINER = XEPDB1;
create user gorm identified by gorm;
-- we need some privs
GRANT CONNECT, RESOURCE, DBA TO gorm;
GRANT CREATE SESSION TO gorm;
GRANT UNLIMITED TABLESPACE TO gorm;