-- Если клиент существует процедура возвращает его ID
-- Если нет то создает новую запись и возвращает ее ID

CREATE OR REPLACE PROCEDURE c##course.pr_create_client (
    client_name     IN  varchar2,        -- Клиент ФИО
    client_birth    IN  date,            -- Дата рождения Клиента
    client_id       OUT number
)
AS
    client_exists number := 0;
BEGIN
    
    SELECT
        COUNT(*) INTO client_exists
        FROM c##course.client
        WHERE
            cl_name = client_name;
    
    IF client_exists > 0 THEN
     SELECT
        id INTO client_id
        FROM c##course.client
        WHERE
            cl_name = client_name;   
    ELSE
        client_id := c##course.seq.nextval;
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
  
    RETURN;

END pr_create_client;
/


/*

SET SERVEROUT ON
/
DECLARE
    client_id number;
BEGIN
    c##course.pr_create_client('Сороколат Андрей Евгеньевич',TO_DATE('30.12.1977','DD.MM.YYYY'),client_id);
    DBMS_OUTPUT.PUT_LINE('client_id = ' || client_id);
END;
*/

