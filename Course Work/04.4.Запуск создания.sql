SET ECHO OFF;
SET VERIFY OFF;
SET SERVEROUTPUT ON;

/

DECLARE
    client_id NUMBER;
    collect_plan NUMBER;
    collect_fact NUMBER;
BEGIN

    SELECT 
        id INTO client_id 
        FROM c##course.client
        WHERE cl_name LIKE '%Сороколат%';
    
    SELECT
          collect_plan
        , collect_fact
         INTO
         collect_plan
       , collect_fact
        FROM c##course.pr_credit
        WHERE id_client = client_id;
        
    
    DBMS_OUTPUT.PUT_LINE('Удаляем старые записи'); 
    DBMS_OUTPUT.PUT_LINE('client_id = ' || client_id); 
    DBMS_OUTPUT.PUT_LINE('collect_plan = ' || collect_plan); 
    DBMS_OUTPUT.PUT_LINE('collect_fact = ' || collect_fact); 
    
    DELETE FROM c##course.fact_oper WHERE collection_id = collect_fact;
    DELETE FROM c##course.plan_oper WHERE collection_id = collect_plan;
    DELETE FROM c##course.pr_credit WHERE id_client = client_id;
    DELETE FROM c##course.client    WHERE id = client_id;
    
    COMMIT;

EXCEPTION
        WHEN OTHERS
            THEN RETURN;
END;
/


ACCEPT client_name PROMPT 'ФИО клиента:  ';
ACCEPT client_birth DATE FORMAT 'dd.mm.yyyy' PROMPT 'Дата рождения клиента в формате ДД.ММ.ГГГГ:  ';
ACCEPT summa_dog PROMPT 'Сумма кредита:  ';
ACCEPT persent_dog PROMPT 'Годовая процентная ставка:  ';
ACCEPT duration_dog PROMPT 'Срок кредитования месяцев:  ';

DECLARE
    dogovor_out varchar(15) := '';
BEGIN

    c##course.pr_create_credit (
         '&client_name'
        ,TO_DATE('&client_birth','DD.MM.YYYY')
        ,TO_NUMBER('&summa_dog')
        ,TO_NUMBER('&persent_dog')
        ,TO_NUMBER('&duration_dog')
        ,dogovor_out
    );


    DBMS_OUTPUT.PUT_LINE('Клиент:' || '&client_name');
    DBMS_OUTPUT.PUT_LINE('Договор:' || dogovor_out);
    DBMS_OUTPUT.PUT_LINE('Cумма кредита:' || '&summa_dog');
    DBMS_OUTPUT.PUT_LINE('Срок кредита:' || '&duration_dog');
    DBMS_OUTPUT.PUT_LINE('Годовая процентная ставка:' || '&persent_dog');
    
    DBMS_OUTPUT.PUT_LINE('График платежей:');
    
    FOR item IN (
        SELECT
            *
            FROM c##course.plan_oper
            WHERE
                collection_id = (
                    SELECT
                        collect_plan
                        FROM c##course.pr_credit
                        WHERE num_dog = dogovor_out
                )
    )
    LOOP
    
            DBMS_OUTPUT.PUT_LINE(
               RPAD(item.p_date,15,' ')
            || RPAD(TO_CHAR(item.p_summa,'9999990.99'),15,' ')
            || RPAD(item.type_oper,40,' ')
            );

    
    END LOOP;
    
    

END;


