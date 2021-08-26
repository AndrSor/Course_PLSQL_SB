CLEAR SCREEN;
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE c##course.pr_pay_credit (client_name IN varchar := 'Сороколат')
IS

    v_collect_fact      NUMBER;
    v_collect_plan      NUMBER;
    v_summa_pay_credit  NUMBER;
    v_summa_pay_percent NUMBER;
    v_f_date            DATE;
    

BEGIN

    SELECT
        collect_fact,collect_plan INTO v_collect_fact,v_collect_plan
        FROM c##course.pr_credit
        WHERE
            id_client = (
                SELECT
                    id
                    FROM c##course.client
                    WHERE
                        cl_name LIKE (client_name || '%')
                    FETCH FIRST 1 ROW ONLY
                    
            );

    SELECT
        p_summa,p_date INTO v_summa_pay_credit,v_f_date
        FROM c##course.plan_oper
        WHERE
            collection_id = v_collect_plan
            AND
            type_oper = 'Погашение кредита'
            AND
            p_date >= TRUNC(SYSDATE)
        ORDER BY p_date
        FETCH FIRST 1 ROW ONLY;

    SELECT
        p_summa INTO v_summa_pay_percent
        FROM c##course.plan_oper
        WHERE
            collection_id = v_collect_plan
            AND
            type_oper = 'Погашение процентов'
            AND
            p_date >= TRUNC(SYSDATE)
        ORDER BY p_date
        FETCH FIRST 1 ROW ONLY;
        
    
    
    DBMS_OUTPUT.PUT_LINE('collect_fact = ' || v_collect_fact);
    DBMS_OUTPUT.PUT_LINE('v_summa_pay_credit = ' || v_summa_pay_credit);
    DBMS_OUTPUT.PUT_LINE('v_summa_pay_percent = ' || v_summa_pay_percent);
    
    INSERT INTO c##course.fact_oper (
         collection_id
        ,f_date
        ,f_summa
        ,type_oper
        ) VALUES (
         v_collect_fact
        ,v_f_date
        ,v_summa_pay_percent
        ,'Погашение процентов'
    );
    INSERT INTO c##course.fact_oper (
         collection_id
        ,f_date
        ,f_summa
        ,type_oper
        ) VALUES (
         v_collect_fact
        ,v_f_date
        ,v_summa_pay_percent
        ,'Погашение кредита'
    );
        
    COMMIT;
        
EXCEPTION        
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Данные для проводки не найдены');
    WHEN OTHERS
    THEN
        ROLLBACK TO add_dog;
        DBMS_OUTPUT.PUT_LINE('В процессе операции возникла ошибка');
        c##course.write_audit(SQLCODE,SUBSTR(SQLERRM, 1, 200));
           
END;

/

EXEC c##course.pr_pay_credit;

/

SELECT
    *
    FROM c##course.fact_oper
    WHERE
        collection_id = (
            SELECT
                collect_fact
                FROM c##course.pr_credit
                WHERE id_client = (
                SELECT
                    id
                    FROM c##course.client
                    WHERE
                        cl_name LIKE ('Сороколат%')
                    FETCH FIRST 1 ROW ONLY
                 )
        )