SELECT
    *
    FROM all_tables
    WHERE
        owner LIKE '%COURSE%';
        
select 
     (select count(*) from client) as client_amount
    ,(select count(*) from pr_credit) as pr_oper_amount
    ,(select count(*) from fact_oper) as fact_oper_amount
    ,(select count(*) from plan_oper) as plan_oper_amount
    FROM DUAL;
