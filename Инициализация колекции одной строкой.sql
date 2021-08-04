/*
CREATE OR REPLACE FUNCTION func1(par1 NUMBER)
RETURN SYS_REFCURSOR
IS
    v_curs SYS_REFCURSOR;

BEGIN
    OPEN v_curs
    FOR
    'SELECT text '
    || 'FROM t1 '            
    || 'WHERE id = '
    || par1;

    RETURN v_curs;
END;
*/
SET SERVEROUTPUT ON;

DECLARE 
    TYPE t_row IS RECORD (id number,name varchar2(20)) ;
    TYPE t_table IS TABLE OF t_row INDEX BY pls_integer;
    
    t1 t_table := t_table(1 => t_row(1,'44'), 2 => t_row(2,'55'));
BEGIN
    FOR i IN 1..t1.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE(t1(i).id);
    END LOOP;
    
END;
