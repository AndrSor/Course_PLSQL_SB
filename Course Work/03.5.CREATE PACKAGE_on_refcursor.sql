CLEAR SCREEN;
SET SERVEROUTPUT ON;

CREATE OR REPLACE PACKAGE c##course.pk_credit_report2 AS   

    PROCEDURE get_report(report_dt DATE, r_c OUT SYS_REFCURSOR);
    
END pk_credit_report2;
/


CREATE OR REPLACE PACKAGE BODY c##course.pk_credit_report2 AS
    
    PROCEDURE get_report (report_dt DATE, r_c OUT SYS_REFCURSOR)

    AS
    
    BEGIN
        OPEN r_c FOR
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
                            dog.date_begin;
                            
    END get_report;
    
    

END pk_credit_report2;

/

-- Тест

DECLARE

    ref_cursor              SYS_REFCURSOR;

    num_dog                 VARCHAR(100);
    cl_name                 VARCHAR2(100);
    summ_dog                NUMBER;
    date_begin              DATE;
    date_end                DATE;
    ostat_dolg              NUMBER;
    need_pogash_percent     NUMBER;

    state_cur BOOLEAN;
    
BEGIN

    c##course.pk_credit_report2.get_report (report_dt => TO_DATE('10.10.2020','DD.MM.YYYY'),r_c => ref_cursor);
    
   LOOP
        FETCH ref_cursor INTO
             num_dog
            ,cl_name
            ,summ_dog
            ,date_begin
            ,date_end
            ,ostat_dolg
            ,need_pogash_percent
        ;
        EXIT WHEN ref_cursor%NOTFOUND; 
            
        DBMS_OUTPUT.PUT_LINE(
               RPAD(num_dog,10,' ')
            || RPAD(c##course.split.get(cl_name,' ',1)||' '||c##course.split.get(cl_name,' ',2)||' '||c##course.split.get(cl_name,' ',0),40,' ')
            || RPAD(TO_CHAR(summ_dog,'9999990.99'),15,' ')
            || RPAD(date_begin,10,' ')
            || RPAD(date_end,10,' ')
            || RPAD(TO_CHAR(ostat_dolg,'9999990.00'),15,' ')
            || RPAD(TO_CHAR(need_pogash_percent,'9999990.99'),15,' ')
        );
            
       END LOOP;
       
       CLOSE ref_cursor;
        
END;


