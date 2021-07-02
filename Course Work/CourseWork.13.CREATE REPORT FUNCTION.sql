
DROP TYPE c##course.table_report;
/
DROP TYPE c##course.report_row;
/
CREATE OR REPLACE TYPE c##course.report_row AS OBJECT
( 
      num_dog             varchar2(10)
    , cl_name             varchar2(100)
    , summa_dog           number
    , date_begin          date 
    , date_end            date
    , ostat_dolg          number
    , need_pogash_percent number
);
/
CREATE OR REPLACE TYPE c##course.table_report AS TABLE OF c##course.report_row;


/

CREATE OR REPLACE FUNCTION c##course.fn_get_report (report_dt DATE)
    RETURN c##course.table_report PIPELINED
    -- Атрибут pipelined означает, что функция является конвейерной, результат возвращается клиенту немедленно при вызове директивы pipe row, 
    -- поэтому оператор return необязателен.
    AS
        result_table_report c##course.table_report;
BEGIN
SELECT 
        c##course.report_row
        (
              dog.num_dog
            , cli.cl_name
            , dog.summa_dog
            , dog.date_begin
            , dog.date_end
            , sum_fact.sum_vidano - NVL(sum_fact.sum_pogasheno,0)
            , NVL(sum_pogasheno_percent_plan.sum_pogasheno_percent_plan,0) - NVL(sum_fact.sum_pogasheno_percent,0)
        )
    BULK COLLECT INTO result_table_report
    FROM
        c##course.pr_credit dog

    INNER JOIN
        c##course.client cli
        ON (dog.id_client = cli.id)
        
    LEFT JOIN
    (
        SELECT
              collection_id
            , SUM(CASE type_oper WHEN 'Выдача кредита'      THEN f_summa ELSE 0 END) AS sum_vidano
            , SUM(CASE type_oper WHEN 'Погашение кредита'   THEN f_summa ELSE 0 END) AS sum_pogasheno
            , SUM(CASE type_oper WHEN 'Погашение процентов' THEN f_summa ELSE 0 END) AS sum_pogasheno_percent
            FROM c##course.fact_oper
            WHERE
                f_date <= c##course.fn_get_report.report_dt
                
            GROUP BY collection_id
    ) sum_fact
    ON (dog.collect_fact = sum_fact.collection_id)

   LEFT JOIN 
   (
        SELECT
            SUM(p_summa) AS sum_pogasheno_percent_plan,
            collection_id
            FROM c##course.plan_oper
            WHERE
                p_date <= c##course.fn_get_report.report_dt
                AND
                type_oper = 'Погашение процентов'
            GROUP BY collection_id
   ) sum_pogasheno_percent_plan
   ON (dog.collect_plan = sum_pogasheno_percent_plan.collection_id)

   WHERE
        dog.date_begin <= c##course.fn_get_report.report_dt
   ORDER BY
        dog.date_begin

    ;

-- FOR loop_counter IN [REVERSE] lowest_number..highest_number LOOP
-- {...statements...}
-- END LOOP;

    FOR i IN 1..result_table_report.count LOOP
        PIPE ROW (c##course.report_row 
        (
              result_table_report(i).num_dog
            , result_table_report(i).cl_name
            , result_table_report(i).summa_dog
            , result_table_report(i).date_begin
            , result_table_report(i).date_end
            , result_table_report(i).ostat_dolg
            , result_table_report(i).need_pogash_percent
        )); 
    END LOOP;     
    RETURN;



END;
    
/