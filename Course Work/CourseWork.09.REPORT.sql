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
    report_dt date = to_date('10.06.2021','DD.MM,RRRR');

SELECT
          dog.num_dog
        , cli.cl_name
        , dog.date_begin
        , dog.date_end
        
    FROM
        c##course.pr_credit dog
    INNER JOIN
        c##course.client cli
    ON
        (dog.id_client = cli.id)
;
        
        
select * from c##course.pr_credit prc where rownum < 5;

