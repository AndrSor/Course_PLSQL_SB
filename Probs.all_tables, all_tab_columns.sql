alter session set container=testdbplug;
--SELECT funConcat('AB','EDF') FROM DUAL
SELECT DISTINCT(OWNER) FROM all_tables;
select * from all_tables /*where rownum < 11*/;
select table_name from all_tables where OWNER = 'HR';

SELECT  table_name, column_name, data_type, data_length FROM all_tab_columns where table_name = 'EMPLOYEES';