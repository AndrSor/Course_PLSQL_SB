CREATE OR REPLACE PROCEDURE c##course.pr_create_client (
    client_name     IN  varchar2,        -- Клиент ФИО
    client_birth    IN  date,            -- Дата рождения Клиента
    client_id       OUT number
)
AS
    client_exists number := 0;
    --client_id number :=0;
BEGIN
    --client_id := 0;
    
    --DBMS_OUTPUT.PUT_LINE('client_name = ' || client_name);
    --DBMS_OUTPUT.PUT_LINE('client_birth = ' || client_birth);
    
    SELECT
        COUNT(*) INTO client_exists
        FROM c##course.client
        WHERE
            cl_name = client_name;
    
    IF client_exists > 0 THEN
     DBMS_OUTPUT.PUT_LINE('Make select');
     SELECT
        id INTO client_id
        FROM c##course.client
        WHERE
            cl_name = client_name;   
    ELSE
        client_id := c##course.seq.nextval;
        DBMS_OUTPUT.PUT_LINE('Make insert');
        INSERT INTO c##course.client
            (
                  id
                , cl_name
                , date_birth
            ) VALUES (
                  client_id
                , client_name
                , client_birth
            );
            COMMIT;

    END IF;
  
    DBMS_OUTPUT.PUT_LINE('client_id = ' || client_id);
    RETURN;

END pr_create_client;
/

SET SERVEROUTPUT ON
/
select TO_DATE('30.12.1977','DD.MM.YYYY') from dual;

DECLARE
    client_id number;
BEGIN
    pr_create_client('Сороколат Андрей Евгеньевич',TO_DATE('30.12.1977','DD.MM.YYYY'),client_id);
    DBMS_OUTPUT.PUT_LINE('client_id = ' || client_id);
END;
/
SELECT * FROM c##course.client ORDER BY cl_name;
/

CREATE OR REPLACE PROCEDURE c##course.pr_create_dog (
    client_name     IN varchar2,        -- Клиент ФИО
    client_birth    IN date,            -- Дата рождения Клиента
    summa_dog       IN number,          -- Сумма кредита
    persent_dog     IN number,          -- Годовая процентная ставка
    duration_dog    IN number           -- Срок кредитования
)
AS
    client_id number;
BEGIN

    DBMS_OUTPUT.PUT_LINE('client_name = ' || client_name);
    DBMS_OUTPUT.PUT_LINE('client_birth = ' || client_birth);
    DBMS_OUTPUT.PUT_LINE('summa_dog = ' || summa_dog);
    DBMS_OUTPUT.PUT_LINE('persent_dog = ' || persent_dog);
    DBMS_OUTPUT.PUT_LINE('duration_dog = ' || duration_dog);
    
    pr_create_client('Сороколат Андрей Евгеньевич',TO_DATE('30.12.1977','DD.MM.YYYY'),client_id);
    
END;
*/
/
