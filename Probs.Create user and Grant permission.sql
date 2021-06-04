--select * from dba_tablespaces;

--show con_name;


------ CHANGE CONTAINER ------
-- alter session set container=testdbplug;

--select * from dba_tablespaces;

------ CREATE USER ------
-- CREATE USER hr IDENTIFIED BY Password1 DEFAULT TABLESPACE USERS;

------ GRANT REPMISSION FOR HR USER ------
-- GRANT CREATE SESSION, CREATE VIEW, ALTER SESSION, CREATE SEQUENCE TO hr;
-- GRANT CREATE SYNONYM, CREATE DATABASE LINK, RESOURCE , UNLIMITED TABLESPACE TO hr;


--ALTER SESSION SET CURRENT_SCHEMA=HR;

---select user from dual;

--select * from countries;


	
select sys_context('userenv','CURRENT_SCHEMA') from dual
