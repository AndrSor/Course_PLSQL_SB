--drop table c##course.plan_oper_external

select * from c##course.plan_oper_external
--where rownum < 20;

select * from c##course.plan_oper
where rownum < 20

select * from c##course.client_external
where rownum < 20


select
    (select count(*) from c##course.plan_oper) as count_plan_oper,
    (select count(*) from c##course.plan_oper_external) as count_plan_oper_external,
    (select count(*) from c##course.fact_oper) as count_fact_oper,
    (select count(*) from c##course.fact_oper_external) as count_fact_oper_external
    
    from dual;


select  ff,count(ff) from 
(
select
    collection_id ||' - '|| p_date ||' - '|| type_oper  as ff
    from plan_oper
) group by ff

having count(ff) > 1;

---

select  ff,count(ff) from 
(
select
    collection_id ||' - '|| p_date ||' - '|| type_oper  as ff
    from plan_oper_external
) group by ff

having count(ff) > 1;

select  * from c##course.plan_oper_external where collection_id = 6217981210248 order by p_date;

SELECT 
    collection_id,
    p_date,
    SUM(p_summa) 
    FROM c##course.plan_oper_external 
    Where collection_id = 6217981210248
group by collection_id,p_date order by collection_id,p_date;

select * from 

select * from c##course.plan_oper_external where type_oper = 'Выдача кредита' and collection_id = 6217981210248;
select sum(p_summa) from c##course.plan_oper_external where type_oper = 'Погашение кредита' and collection_id = 6217981210248



