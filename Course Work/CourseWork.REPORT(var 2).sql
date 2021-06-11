SET SERVEROUTPUT ON

SET FEEDBACK OFF
SET ECHO OFF
SET VERIFY OFF

REM Построение отчета
REM – Номер договора (поле таблицы PR_CRED.NUM_DOG);
REM – ФИО клиента (поле таблицы CLIENT.CL_NAME);
REM – Сумма договора (поле таблицы PR_CRED.SUMMA_DOG);
REM – Дата начала договора (поле таблицы PR_CRED.DATE_BEGIN);
REM – Дата окончания договора (поле таблицы PR_CRED.DATE_END);
REM – Остаток ссудной задолженности на дату 
REM   (разница между суммой фактической выдачи и суммой фактических погашений кредита, проведенных до даты отчета включительно);
REM – Сумма предстоящих процентов к погашению 
REM   (разница между суммой всех плановых погашений процентов и суммой фактических погашений процентов, проведенных до даты отчета включительно).
REM – REPORT_DT – Дата-время формирования отчета.

DECLARE 
    report_dt date;
    t number;
BEGIN

report_dt := to_date('10.10.2020','DD.MM,RRRR');
t := 0;

FOR i IN (
SELECT
          dog.num_dog
        , cli.cl_name
        , TO_CHAR(dog.summa_dog,'999999999990.00') AS summa_dog
        , dog.date_begin
        , dog.date_end
        , TO_CHAR((sum_fact.sum_vidano - NVL(sum_fact.sum_pogasheno,0)),'999999999990.00') AS ostat_dolg
        , TO_CHAR(NVL(sum_pogasheno_percent_plan.sum_pogasheno_percent_plan,0) - NVL(sum_fact.sum_pogasheno_percent,0),'999999999990.99') AS need_pogash_percent
        
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

) loop
t := t + 1;
dbms_output.put_line(
    t               || chr(9) ||
    i.num_dog       || chr(9) || chr(9) ||
    i.cl_name       || chr(9) || chr(9) ||
    i.summa_dog     || chr(9) || chr(9) ||
    i.date_begin    || chr(9) || chr(9) ||
    i.date_end      || chr(9) || chr(9) ||
    i.ostat_dolg    || chr(9) || chr(9) ||
    i.need_pogash_percent
);

end loop;
        
        

END;
