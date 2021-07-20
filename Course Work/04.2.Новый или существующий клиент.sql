SET SERVEROUT ON
/

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


/*
DECLARE
    client_id number;
BEGIN
    c##course.pr_create_client('Сороколат Андрей Евгеньевич',TO_DATE('30.12.1977','DD.MM.YYYY'),client_id);
    DBMS_OUTPUT.PUT_LINE('client_id = ' || client_id);
END;
*/
/
