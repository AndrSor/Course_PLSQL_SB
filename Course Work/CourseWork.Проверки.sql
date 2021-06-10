SELECT
    *
    FROM all_tables
    WHERE
        --rownum < 10
        --and
        owner LIKE '%COURSE%';
        
select 
     (select count(*) from c##course.client) as client_amount
    ,(select count(*) from c##course.pr_credit) as pr_oper_amount
    ,(select count(*) from c##course.fact_oper) as fact_oper_amount
    ,(select count(*) from c##course.plan_oper) as plan_oper_amount
    FROM DUAL;
