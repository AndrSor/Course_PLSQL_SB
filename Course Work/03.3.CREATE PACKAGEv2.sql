CREATE OR REPLACE PACKAGE c##course.pk_credit_report_v2 AS   
    TYPE report_row IS RECORD
    ( 
          num_dog             varchar2(10)
        , cl_name             varchar2(100)
        , summa_dog           number
        , date_begin          date 
        , date_end            date
        , ostat_dolg          number
        , need_pogash_percent number
    );

    TYPE table_report IS TABLE OF report_row;
    result_table_report table_report;
    
    -- Вариант с конвеерной функцией
    
    PROCEDURE init (report_dt IN DATE);
    
    FUNCTION fn_get_report RETURN table_report PIPELINED;
    
END pk_credit_report_v2;
/


CREATE OR REPLACE PACKAGE BODY c##course.pk_credit_report_v2 AS

    PROCEDURE init (report_dt IN DATE)
    IS
    BEGIN
    
        SELECT * BULK COLLECT INTO result_table_report FROM 
            (
                    SELECT
                          dog.num_dog                       AS num_dog
                        , cli.cl_name                       AS cl_name
                        , dog.summa_dog                     AS summa_dog
                        , dog.date_begin                    AS date_begin
                        , dog.date_end                      AS date_end
                        , fact.sum_vidano - NVL(fact.sum_pogasheno,0)
                                                            AS ostat_dolg
                        , NVL(plan.sum_pogasheno_percent,0) - NVL(fact.sum_pogasheno_percent,0)
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
                            dog.date_begin <= report_dt
                       ORDER BY
                            dog.date_begin            
            ) q;
    
    END init;

    --
    --
    --
    FUNCTION fn_get_report RETURN table_report PIPELINED 
    IS
    BEGIN
     
    FOR i IN 1..result_table_report.count LOOP
        PIPE ROW (report_row 
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

    END fn_get_report;
    
    
 
END pk_credit_report_v2;
/

SET SERVEROUTPUT ON

/

-- Тест

-- использование в контексте SQL 
ACCEPT dt_report DATE FORMAT 'dd.mm.yyyy' PROMPT 'Введите дату отчета:  ';
EXECUTE c##course.pk_credit_report_v2.init (TO_DATE('&dt_report','DD.MM.YYYY'));
SELECT * FROM TABLE(c##course.pk_credit_report_v2.fn_get_report);


-- использование в контексте PL/SQL 
CLEAR SCREEN;
SET SERVEROUTPUT ON;
ACCEPT dt_report DATE FORMAT 'dd.mm.yyyy' PROMPT 'Введите дату отчета:  ';

BEGIN

    c##course.pk_credit_report_v2.init (TO_DATE('&dt_report','DD.MM.YYYY'));

    FOR item IN (SELECT * FROM TABLE(c##course.pk_credit_report_v2.fn_get_report)) LOOP
    
        DBMS_OUTPUT.PUT_LINE(
               RPAD(item.num_dog,10,' ')
            || RPAD(item.cl_name,40,' ')
            || RPAD(TO_CHAR(item.summa_dog,'9999990.99'),15,' ')
            || RPAD(item.date_begin,10,' ')
            || RPAD(item.date_end,10,' ')
            || RPAD(TO_CHAR(item.ostat_dolg,'9999990.00'),15,' ')
            || RPAD(TO_CHAR(item.need_pogash_percent,'9999990.99'),15,' ')
        );
    
    END LOOP;

END;






