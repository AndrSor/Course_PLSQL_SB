-- directory_import


CLEAR SCREEN

SET SERVEROUTPUT ON

DECLARE

ff UTL_FILE.FILE_TYPE;

BEGIN

ff := UTL_FILE.FOPEN('c:\Temp','text.xml','w');
UTL_FILE.PUT_LINE(ff,'USERNAME'||'ATTEMPTS'||'LIFE'||'LOCK'||'');

/*
EXCEPTION

    WHEN OTHERS
    THEN
        RETURN;
*/        

END;