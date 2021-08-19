CREATE OR REPLACE PROCEDURE c##course.pr_import
IS

BEGIN

------ import or update CLIENT

MERGE INTO c##course.client client
    USING c##course.client_external client_external
        ON (client.id = client_external.id) 
    WHEN MATCHED THEN
        UPDATE SET
              client.cl_name     = client_external.cl_name
            , client.date_birth  = client_external.date_birth
    WHEN NOT MATCHED THEN
        INSERT 
            (
                client.id
              , client.cl_name
              , client.date_birth
            )
            VALUES
            (
                client_external.id
              , client_external.cl_name
              , client_external.date_birth
            );

------ import or update PR_CREDIT
  
MERGE INTO c##course.pr_credit pr_credit
    USING c##course.pr_credit_external pr_credit_external
        ON (pr_credit.id = pr_credit_external.id) 
    WHEN MATCHED THEN
        UPDATE SET
              pr_credit.num_dog      = pr_credit_external.num_dog
            , pr_credit.summa_dog    = TO_NUMBER(pr_credit_external.summa_dog)
            , pr_credit.date_begin   = pr_credit_external.date_begin
            , pr_credit.date_end     = pr_credit_external.date_end
            , pr_credit.id_client    = pr_credit_external.id_client
            , pr_credit.collect_plan = pr_credit_external.collect_plan
            , pr_credit.collect_fact = pr_credit_external.collect_fact
    WHEN NOT MATCHED THEN
        INSERT 
            (
                pr_credit.id
              , pr_credit.num_dog
              , pr_credit.date_begin
              , pr_credit.date_end
              , pr_credit.id_client
              , pr_credit.collect_plan
              , pr_credit.collect_fact
            )
            VALUES
            (
                pr_credit_external.id
              , TO_NUMBER(pr_credit_external.summa_dog)
              , pr_credit_external.date_begin
              , pr_credit_external.date_end
              , pr_credit_external.id_client
              , pr_credit_external.collect_plan
              , pr_credit_external.collect_fact
            );

------ import or update PLAN_OPER

--DELETE FROM c##course.plan_oper;

MERGE INTO c##course.plan_oper plan_oper
    USING
            (SELECT
            *
            FROM c##course.plan_oper_external
            ORDER BY p_date
        ) plan_oper_external
        ON (
                plan_oper.collection_id = plan_oper_external.collection_id
                AND
                plan_oper.p_date = plan_oper_external.p_date
                AND
                plan_oper.type_oper = plan_oper_external.type_oper
            ) 
--    WHEN MATCHED THEN
--        UPDATE SET
--              plan_oper.p_summa    = TO_NUMBER(plan_oper_external.p_summa)
    WHEN NOT MATCHED THEN
        INSERT 
            (
                plan_oper.collection_id
              , plan_oper.p_date
              , plan_oper.p_summa
              , plan_oper.type_oper
            )
            VALUES
            (
                plan_oper_external.collection_id
              , plan_oper_external.p_date
              , TO_NUMBER(plan_oper_external.p_summa)
              , plan_oper_external.type_oper
            );

------ import or update FACT_OPER

--DELETE FROM c##course.fact_oper;

MERGE INTO c##course.fact_oper fact_oper
    USING 
        (SELECT
            *
            FROM c##course.fact_oper_external
            ORDER BY f_date
        ) fact_oper_external
        ON  (
                fact_oper.collection_id = fact_oper_external.collection_id
                AND
                fact_oper.f_date = fact_oper_external.f_date
                AND
                fact_oper.type_oper = fact_oper_external.type_oper
            )
--    WHEN MATCHED THEN
--        UPDATE SET
--            fact_oper.f_summa    = TO_NUMBER(fact_oper_external.f_summa)
    WHEN NOT MATCHED THEN
        INSERT
            (
                fact_oper.collection_id
              , fact_oper.f_date
              , fact_oper.f_summa
              , fact_oper.type_oper
            )
            VALUES
            (
                fact_oper_external.collection_id
              , fact_oper_external.f_date
              , TO_NUMBER(fact_oper_external.f_summa)
              , fact_oper_external.type_oper
            );

    COMMIT;

END pr_import;
/

EXECUTE c##course.pr_import;


--CONNECT SYSDBA
--GRANT CREATE JOB TO c##course;

DECLARE
    job_count integer := 0;
BEGIN


    SELECT
        COUNT(*) INTO job_count
        FROM ALL_SCHEDULER_JOBS
        WHERE JOB_NAME = 'JOB_IMPORT';
        
    IF job_count > 0 THEN
        BEGIN
            DBMS_SCHEDULER.DROP_JOB(job_name => 'c##course.job_import');
        END;
    END IF;

    DBMS_SCHEDULER.CREATE_JOB (
            job_name => 'c##course.job_import',
            job_type => 'STORED_PROCEDURE',
            job_action => 'c##course.pr_import',
            number_of_arguments => 0,
            start_date => TO_TIMESTAMP_TZ('2021-07-23 15:52:32.141000000 EUROPE/MOSCOW','YYYY-MM-DD HH24:MI:SS.FF TZR'),
            repeat_interval => 'FREQ=HOURLY;INTERVAL=24',
            end_date => NULL,
            enabled => TRUE,
            auto_drop => FALSE,
            comments => 'Import Job');

         
END;


