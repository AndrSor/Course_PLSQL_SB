CREATE OR REPLACE PACKAGE BODY c##course.pk_credit_report AS

    FUNCTION fn_get_report (report_dt DATE)
        RETURN table_report
        IS
            result_table_report table_report := table_report();
     BEGIN

        FOR row_r IN (
                    SELECT
                          dog.num_dog                       AS num_dog
                        , cli.cl_name                       AS cl_name
                        , dog.summa_dog                     AS summa_dog
                        , dog.date_begin                    AS date_begin
                        , dog.date_end                      AS date_end
                        , sum_fact.sum_vidano - NVL(sum_fact.sum_pogasheno,0)
                                                            AS ostat_dolg
                        , NVL(sum_pogasheno_percent_plan.sum_pogasheno_percent_plan,0) - NVL(sum_fact.sum_pogasheno_percent,0)
                                                            AS need_pogash_percent
                        
                        FROM c##course.pr_credit dog
        
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
                                    f_date <= report_dt
                
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
                                    p_date <= report_dt
                                    AND
                                    type_oper = 'Погашение процентов'
                                GROUP BY collection_id
                       ) sum_pogasheno_percent_plan
                       ON (dog.collect_plan = sum_pogasheno_percent_plan.collection_id)
                
                       WHERE
                            dog.date_begin <= report_dt
                       ORDER BY
                            dog.date_begin
                    )
        LOOP

            --NULL;
            result_table_report.EXTEND;
            result_table_report(result_table_report.LAST).num_dog       := row_r.num_dog;
            result_table_report(result_table_report.LAST).cl_name       := row_r.cl_name;
            result_table_report(result_table_report.LAST).summa_dog     := row_r.summa_dog;
            result_table_report(result_table_report.LAST).date_begin    := row_r.date_begin;
            result_table_report(result_table_report.LAST).date_end      := row_r.date_end;
            result_table_report(result_table_report.LAST).ostat_dolg    := row_r.ostat_dolg;
            
    
        END LOOP;
        
        RETURN result_table_report;

    END fn_get_report;
    
END pk_credit_report;
