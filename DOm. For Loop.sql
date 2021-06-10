

DECLARE 
    t NUMBER;
BEGIN


    t := 0;
    
    FOR i IN (
        SELECT * FROM all_objects WHERE rownum < 11
    ) LOOP
    
    
        DBMS_OUTPUT.PUT_LINE(i.object_name || CHR(9) || CHR(9) || i.object_type);
    
    END LOOP;



END;
