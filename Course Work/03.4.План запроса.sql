--VARIABLE dt_report VARCHAR2(10);
CLEAR SCREEN

EXPLAIN PLAN FOR
SELECT
              dog.num_dog
            , cli.cl_name
            , dog.summa_dog
            , dog.date_begin
            , dog.date_end
            -- Остаток ссудной задолженности 
            , fact.sum_vidano - NVL(fact.sum_pogasheno,0) AS ostst
            -- Сумма предстоящих процентов к погашению 
            , NVL(plan.sum_pogasheno_percent,0) - NVL(fact.sum_pogasheno_percent,0) AS ostst_pr

    FROM
        c##course.pr_credit dog

    INNER JOIN
        c##course.client cli
        ON (dog.id_client = cli.id)
        
    LEFT JOIN
    (
        SELECT  /*+ index(idx_fact_oper_f_date) */
              collection_id
            , SUM(CASE type_oper WHEN 'Выдача кредита'      THEN f_summa ELSE 0 END) AS sum_vidano
            , SUM(CASE type_oper WHEN 'Погашение кредита'   THEN f_summa ELSE 0 END) AS sum_pogasheno
            , SUM(CASE type_oper WHEN 'Погашение процентов' THEN f_summa ELSE 0 END) AS sum_pogasheno_percent
            FROM c##course.fact_oper
            WHERE
                f_date <= TO_DATE(':dt_report','DD.MM.YYYY')
                
            GROUP BY collection_id
    ) fact
    ON (dog.collect_fact = fact.collection_id)

   LEFT JOIN 
   (
        SELECT
            SUM(p_summa) AS sum_pogasheno_percent,
            collection_id
            FROM c##course.plan_oper
            WHERE
                type_oper = 'Погашение процентов'
            GROUP BY collection_id
   ) plan
   ON (dog.collect_plan = plan.collection_id)

   WHERE
        dog.date_begin <= TO_DATE(':dt_report','DD.MM.YYYY')
   ORDER BY
        dog.date_begin
;

select * from table(DBMS_XPLAN.DISPLAY(format => 'ALL'));

