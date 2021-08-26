SELECT
    t,
    count(t)
    FROM 
        (
            SELECT
                (collection_id || '-' || p_date || '-' || type_oper) AS t
                FROM c##course.plan_oper
        ) t
            
    GROUP BY t
    HAVING COUNT(t) > 1;
    
select * from c##course.plan_oper where collection_id = 6333805292633;
