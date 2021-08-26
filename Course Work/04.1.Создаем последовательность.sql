DROP SEQUENCE c##course.seq;
CLEAR SCREEN;

CREATE OR REPLACE VIEW c##course.v_all_id
AS

        SELECT
            id
            FROM c##course.client client
        
        UNION ALL
        
        SELECT
            id
            FROM c##course.pr_credit pr_credit
            
        UNION ALL
        
        SELECT
            collect_plan AS id
            FROM c##course.pr_credit pr_credit
            
        UNION ALL
        
        SELECT 
            collect_fact AS id
            FROM c##course.pr_credit pr_credit
;
/

-- Идентификаторы во всех таблицах уникальны
-- Создаем одну последовательность генерирующую
-- индентификаторы для всех таблиц
-- со стартовым значением максимальный ID + 1

DECLARE
    count_all_id        NUMBER;
    count_distinct_id   NUMBER;
    start_id            NUMBER;
    sequence_exist      NUMBER := 0;
BEGIN

    SELECT
        COUNT(id) INTO count_all_id
        FROM 
            c##course.v_all_id v_all_id;
    
    SELECT
        COUNT(DISTINCT id) INTO count_distinct_id
        FROM
            c##course.v_all_id v_all_id;
        
    IF (count_distinct_id = count_all_id) THEN
    
            SELECT
                MAX(id) + 1 INTO start_id
                FROM c##course.v_all_id;
                
            -- Для создания последовательности пользователь должен обладать правами
            --GRANT CREATE ANY SEQUENCE, ALTER ANY SEQUENCE, DROP ANY SEQUENCE, SELECT ANY SEQUENCE TO c##course;
			--GRANT CREATE ANY PROCEDURE, ALTER ANY PROCEDURE, DROP ANY PROCEDURE, EXECUTE ANY PROCEDURE TO c##course;
            
            SELECT COUNT(*) INTO sequence_exist FROM USER_OBJECTS WHERE object_name = 'SEQ';
            IF (sequence_exist > 0) THEN
                EXECUTE IMMEDIATE 'DROP SEQUENCE c##course.seq';
            END IF;
           
            EXECUTE IMMEDIATE 'CREATE SEQUENCE c##course.seq START WITH ' || start_id || ' INCREMENT BY 1';
        
    END IF;

END;
/