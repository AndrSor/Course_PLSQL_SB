EXPLAIN PLAN FOR
SELECT 
              dog.num_dog
            , cli.cl_name
            , dog.summa_dog
            , dog.date_begin
            , dog.date_end
            -- Остаток ссудной задолженности 
            , sum_fact.sum_vidano - NVL(sum_fact.sum_pogasheno,0)
            -- Сумма предстоящих процентов к погашению 
            , NVL(sum_pogasheno_percent_plan.sum_pogasheno_percent_plan,0) - NVL(sum_fact.sum_pogasheno_percent,0)


    FROM
        c##course.pr_credit dog

    INNER JOIN
        c##course.client cli
        ON (dog.id_client = cli.id)
        
    LEFT JOIN
    (
        SELECT /*+ INDEX(IDX_FACT_OPER_F_DATE) */
              collection_id
            , SUM(CASE type_oper WHEN 'Выдача кредита'      THEN f_summa ELSE 0 END) AS sum_vidano
            , SUM(CASE type_oper WHEN 'Погашение кредита'   THEN f_summa ELSE 0 END) AS sum_pogasheno
            , SUM(CASE type_oper WHEN 'Погашение процентов' THEN f_summa ELSE 0 END) AS sum_pogasheno_percent
            FROM c##course.fact_oper
            WHERE
                f_date <= TO_DATE('10.10.2020','DD.MM.YYYY')
                
            GROUP BY collection_id
    ) sum_fact
    ON (dog.collect_fact = sum_fact.collection_id)

   LEFT JOIN 
   (
        SELECT  /*+ INDEX(IDX_PLAN_OPER_P_DATE) */
            SUM(p_summa) AS sum_pogasheno_percent_plan,
            collection_id
            FROM c##course.plan_oper
            WHERE
                p_date <= TO_DATE('10.10.2020','DD.MM.YYYY')
                AND
                type_oper = 'Погашение процентов'
            GROUP BY collection_id
   ) sum_pogasheno_percent_plan
   ON (dog.collect_plan = sum_pogasheno_percent_plan.collection_id)

   WHERE
        dog.date_begin <= TO_DATE('10.10.2020','DD.MM.YYYY')
   ORDER BY
        dog.date_begin
;

--select * from table(DBMS_XPLAN.DISPLAY(format => 'ALL'));

