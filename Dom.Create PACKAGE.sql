CREATE OR REPLACE PACKAGE c##course.pk_test IS

    TYPE items IS TABLE OF c##course.client%ROWTYPE;

    FUNCTION fn_t1(i1 NUMBER,i2 NUMBER) RETURN NUMBER;
    
    FUNCTION fn_t2(row_number NUMBER) RETURN items;
    
    PROCEDURE pr_t2 (row_number IN NUMBER);
    
END pk_test;
/

CREATE OR REPLACE PACKAGE BODY c##course.pk_test IS

    FUNCTION fn_t1(i1 NUMBER,i2 NUMBER)
        RETURN NUMBER
    IS
        summ NUMBER := 0;
    BEGIN
        summ := i1 + i2;
        RETURN summ;
    END fn_t1  ;


    FUNCTION fn_t2(row_number NUMBER)
        RETURN items
    IS
        clients_collection items := items();
    BEGIN
        
        FOR item IN (SELECT * FROM c##course.client WHERE rownum < row_number) LOOP
            
            clients_collection.EXTEND;
            clients_collection(clients_collection.LAST).id := item.id;
        
        END LOOP;
        
        RETURN clients_collection;
        
    END fn_t2;
    
    -- PROCEDURE for fn_t2
    
    PROCEDURE pr_t2 (row_number IN NUMBER)
    IS
        r_count NUMBER;
        r_t items := fn_t2(row_number);
    BEGIN
    
        /*
        FOR item IN (
            SELECT * FROM fn_t2(3)
        ) LOOP
        
            DBMS_OUTPUT.PUT_LINE(item.id);
        
        END LOOP;
        */
        SELECT  COUNT(*) INTO r_count FROM TABLE(r_t);
        DBMS_OUTPUT.PUT_LINE(r_count);
        
        --NULL;
    
    END pr_t2;



END pk_test;
/


SET SERVEROUTPUT ON
/

DECLARE 
    t1 c##course.pk_test.items := c##course.pk_test.items();
BEGIN

    --DBMS_OUTPUT.PUT_LINE(c##course.pk_test.fn_t1(1,2));
    t1 := c##course.pk_test.fn_t2(2);
    FOR item IN (SELECT * FROM TABLE(t1)) LOOP
        DBMS_OUTPUT.PUT_LINE(item.id);
    END LOOP;

END;
/

SELECT * FROM TABLE(c##course.pk_test.fn_t2(3));

/

EXECUTE c##course.pk_test.pr_t2(4);