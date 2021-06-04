alter session set container=testdbplug;
--SELECT funConcat('AB','EDF') FROM DUAL
SELECT DISTINCT(OWNER) FROM all_tables;
select * from all_tables /*where rownum < 11*/;
select table_name from all_tables where OWNER = 'HR';