set verify off;

--define from_date;



ACCEPT hired DATE FORMAT 'dd.mm.yyyy' PROMPT 'Дата:  ';

DEFINE spool_file = 'c:\Temp\lox.txt';
SPOOL &spool_file

select '&&hired',&from_date from dual;

--select max(P_DATE) INTO &from_date FROM c##course.plan_oper;







