EXPLAIN PLAN SET statement_id = 'test2' FOR 
    SELECT
        *
        FROM c##course.client
        WHERE cl_name IN
            (
                SELECT 'Сороколат Андрей' FROM DUAL 
                UNION 
                SELECT 'Константин Петров' FROM DUAL
            );


SELECT
    lpad(' ',level-1)||operation||' '||options||' '|| object_name Plan
    FROM plan_table
    CONNECT BY 
        prior id = parent_id
        AND
        prior statement_id = statement_id
    START WITH id = 0 AND statement_id = 'test2'
    ORDER BY id;

--SELECT * FROM plan_table where ;

SELECT * FROM table (DBMS_XPLAN.DISPLAY);


