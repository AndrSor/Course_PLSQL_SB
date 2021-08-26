
SELECT 
    *
    FROM
        (
            SELECT
                 LEVEL
                ,TRUNC(dbms_random.value(1,4))
                FROM DUAL
                CONNECT BY LEVEL < 100
        ) tmp
    
    FETCH FIRST 9 ROWS ONLY;


SELECT 
    *
    FROM
        (
            SELECT
                 LEVEL ll
                ,TRUNC(dbms_random.value(1,4)) num_num
                FROM DUAL
                CONNECT BY LEVEL < 100
        ) tmp
    ORDER BY num_num
    OFFSET 9 ROWS FETCH NEXT 18 ROWS ONLY;
    
    

