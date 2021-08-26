CLEAR SCREEN;
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE c##course.pr_giv_credit (client_name IN varchar := 'Сороколат')
IS

    v_collect_fact    NUMBER;
    v_summa_dog       NUMBER;
    v_amount_giv      NUMBER := 0;

BEGIN

    SELECT
         collect_fact ,summa_dog INTO v_collect_fact,v_summa_dog
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
        COUNT(*) INTO v_amount_giv
        FROM c##course.fact_oper
        WHERE
            collection_id = v_collect_fact
            AND
            type_oper = 'Выдача кредита';
            
    IF v_amount_giv > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Этому Клиету кредит уже выдан');
        RETURN;
    END IF;
    
    
    --DBMS_OUTPUT.PUT_LINE('collect_fact = ' || v_collect_fact);
    --DBMS_OUTPUT.PUT_LINE('summa_dog = ' || v_summa_dog);
    
    INSERT INTO c##course.fact_oper (
         collection_id
        ,f_date
        ,f_summa
        ,type_oper
        ) VALUES (
         v_collect_fact
        ,TRUNC(SYSDATE)
        ,v_summa_dog
        ,'Выдача кредита'
    );
        
    COMMIT;
        
EXCEPTION        
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Такой клиент не найден проверьте правильность введенной информации');
    WHEN OTHERS
    THEN
        ROLLBACK TO add_dog;
        DBMS_OUTPUT.PUT_LINE('В процессе операции возникла ошибка');
        c##course.write_audit(SQLCODE,SUBSTR(SQLERRM, 1, 200));
           
END;

/

EXEC c##course.pr_giv_credit;

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