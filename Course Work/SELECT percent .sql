SELECT DISTINCT(type_oper) FROM c##course.plan_oper;
SELECT DISTINCT(type_oper) FROM c##course.fact_oper;


SELECT
    SUM(f_summa) AS vipl_percent_fact,
    collection_id
    FROM c##course.fact_oper
    WHERE
        f_date <= TO_DATE('10.10.2020','DD.MM.RRRR')
        AND
        type_oper = 'Погашение процентов'
    GROUP BY collection_id
    
    ;
            
        
SELECT
    SUM(f_summa) AS vipl_percent_plan,
    collection_id
    FROM c##course.plan_oper
    WHERE
        p_date <= TO_DATE('10.10.2020','DD.MM.RRRR')
        AND
        type_oper = 'Погашение процентов'
    GROUP BY collection_id
    
    ;
            
