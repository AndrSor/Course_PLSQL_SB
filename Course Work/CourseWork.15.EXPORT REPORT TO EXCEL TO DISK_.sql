
SET ECHO OFF
SET VERIFY OFF
SET SERVEROUTPUT ON
/


-- Запрашиваем Дату отчета
ACCEPT dt_report CHAR PROMPT 'Введите дату отчета: '

-- Имя файла отчета отражает Дату отчета
DEFINE spool_file = 'c:\Temp\&dt_report..xls'
SPOOL &spool_file
/

--SELECT * FROM TABLE( c##course.fn_get_report (to_date('&dt_report','DD.MM.YYYY')) )

BEGIN

    FOR items IN
        (
            SELECT
                c##course.fn_make_report (to_date('&dt_report','DD.MM.YYYY')) AS st
                FROM DUAL
        )
    LOOP
        DBMS_OUTPUT.PUT_LINE(items.st);
    END LOOP;

END;

/

SPOOL OFF
