-- SET SERVEROUT ON
/
REM SELECT USER FROM DUAL


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
        --BEGIN
            DBMS_OUTPUT.PUT_LINE('Идентификаторы в столбцах:' || CHR(10) ||
                                 'client.id, pr_credit.id, pr_credit.collect_plan, pr_credit.collect_fact' || CHR(10) ||
                                 'уникальны.' || CHR(10) ||
                                 'Можно создать ПОСЛЕДОВАТЕЛЬНОСТЬ со стартовым значением' || CHR(10) ||
                                 'которое будет равняться максимальному ID + 1');
    
            SELECT
                MAX(id) + 1 INTO start_id
                FROM c##course.v_all_id;
                
            DBMS_OUTPUT.PUT_LINE('START ID = ' || start_id);
            
            --GRANT CREATE ANY SEQUENCE, ALTER ANY SEQUENCE, DROP ANY SEQUENCE, SELECT ANY SEQUENCE TO c##course;
			--GRANT CREATE ANY PROCEDURE, ALTER ANY PROCEDURE, DROP ANY PROCEDURE, EXECUTE ANY PROCEDURE TO c##course;
            
            SELECT COUNT(*) INTO sequence_exist FROM USER_OBJECTS WHERE object_name = 'SEQ';
            IF (sequence_exist > 0) THEN
                EXECUTE IMMEDIATE 'DROP SEQUENCE c##course.seq';
            END IF;
           
            EXECUTE IMMEDIATE 'CREATE SEQUENCE c##course.seq START WITH ' || start_id || ' INCREMENT BY 1';
        
        --END;
    END IF;

END;
/