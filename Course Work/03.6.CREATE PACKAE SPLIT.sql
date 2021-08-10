/*
|
|   Перет SPLIT с перегруженной функцией  GET
|
*/

CREATE OR REPLACE PACKAGE c##course.split AS
    
    TYPE arr IS TABLE OF CLOB INDEX BY PLS_INTEGER;
    
    -- get return Index of Collection
    FUNCTION get
        (
             str        CLOB
            ,delim      CLOB
            ,get_index  PLS_INTEGER
        )
        RETURN CLOB;
        
    -- getArr return Collection
    FUNCTION get
        (
             str        CLOB
            ,delim      CLOB
        )
        RETURN arr;
        
    -- length return Length of Collection
    FUNCTION getlen
        (
             str        CLOB
            ,delim      CLOB
        )
        RETURN PLS_INTEGER;
    

END split;
/



CREATE OR REPLACE PACKAGE BODY c##course.split AS

    FUNCTION get
        (
             str        CLOB
            ,delim      CLOB
            ,get_index  PLS_INTEGER
        )
        RETURN CLOB
    IS
    
        res CLOB := '';
      
    BEGIN
      
        IF(LENGTH(str) > 0 AND INSTR(str, delim) = 0) THEN
            res := '';
        ELSIF (LENGTH(str) > 0 AND INSTR(str, delim) > 0 AND get_index = 0) THEN
            res := SUBSTR(str,1, INSTR(str, delim)-1);
        ELSIF (INSTR(str, delim, 1, get_index) > 0 AND INSTR(str, delim, 1, get_index + 1) = 0) THEN
            res := SUBSTR(str, (INSTR(str, delim, 1, get_index) + LENGTH(delim)));
        ELSE
            res := SUBSTR(str, (INSTR(str, delim, 1, get_index) + LENGTH(delim)),INSTR(str, delim, 1, get_index + 1)-(INSTR(str, delim, 1, get_index) + LENGTH(delim)));
        END IF;
    
        RETURN res;
      
    EXCEPTION 
        WHEN OTHERS THEN
          IF SQLCODE = -06532 THEN
            RETURN '';
        END IF;
      
    END get;
    
    
    /*
    |
    | Return Collection
    |
    */
    FUNCTION get
        (
             str        CLOB
            ,delim      CLOB
        )
        RETURN arr
    IS

        get_index   PLS_INTEGER := 0;
        res arr;
      
    BEGIN
      
        
        IF INSTR(str, delim) > 0 THEN
        
            LOOP
                
                IF(LENGTH(str) > 0 AND INSTR(str, delim) = 0) THEN
                    BEGIN
                        res(get_index) := '';
                    END;
                    
                ELSIF (LENGTH(str) > 0 AND INSTR(str, delim) > 0 AND get_index = 0) THEN
                    BEGIN
                        res(get_index) := SUBSTR(str,1, INSTR(str, delim)-1);
                    END;
                    
                ELSIF (INSTR(str, delim, 1, get_index) > 0 AND INSTR(str, delim, 1, get_index + 1) = 0) THEN
                    BEGIN
                        res(get_index) := SUBSTR(str, (INSTR(str, delim, 1, get_index) + LENGTH(delim)));
                    END;
                    
                ELSE
                    BEGIN
                        res(get_index) := SUBSTR(str, (INSTR(str, delim, 1, get_index) + LENGTH(delim)),INSTR(str, delim, 1, get_index + 1)-(INSTR(str, delim, 1, get_index) + LENGTH(delim)));
                    END;
                    
                END IF;
                
                get_index := get_index + 1;
                
                EXIT WHEN
                    INSTR(str, delim,1, get_index) = 0
                    ;
            
            END LOOP;

        END IF;
    
    
        RETURN res;
      
      
    END get;
    
    
    /*
    |
    | Return Length of Collection
    |
    */
    FUNCTION getlen
        (
             str        CLOB
            ,delim      CLOB
        )
        RETURN PLS_INTEGER
    IS

        res arr;
      
    BEGIN
    
        NULL;
    
    END getlen;
    
END split;

/


/*
|
| TEST
|
*/
DECLARE 
    res c##course.split.arr;
BEGIN

    DBMS_OUTPUT.PUT_LINE(c##course.split.get('86412;774;900823981,233;22.22',';',2));

    res := c##course.split.get('ghghgh<br>77777<br>777DD777<br>666<tr>','<br>');
   
    FOR i IN res.FIRST..res.LAST 
    LOOP
        DBMS_OUTPUT.PUT_LINE('res(' || i || ') = ' || res(i));
    END LOOP;
    
    
END;
