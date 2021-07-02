SET FEEDBACK OFF
SET ECHO OFF
SET VERIFY OFF
SET SERVEROUTPUT ON
/
REM Запрашиваем Дату отчета
DEFINE dt = &1
REM Имя файла отчета отражает Дату отчета
DEFINE spool_file = 'c:\Temp\&dt..xls'
SPOOL &spool_file
/

BEGIN

    FOR i IN (select c##course.fn_make_report (to_date('&dt','DD.MM.YYYY')) AS st FROM dual) LOOP
        DBMS_OUTPUT.PUT_LINE(i.st);
    END LOOP;

END;
/

SPOOL OFF
