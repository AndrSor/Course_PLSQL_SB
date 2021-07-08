--
-- Удаление таблицы AUDIT_TABLE
--
DROP TABLE c##course.audit_table;
/
--
-- Создание таблицы плановые операции
--

CREATE TABLE c##course.audit_table (
      sqlcode             NUMBER
    , sqlerrm             VARCHAR2(200)
    , current_user        VARCHAR2(200)     DEFAULT USER
    , dt                  TIMESTAMP         DEFAULT SYSDATE
   
);
/


SET TIMING ON
/

DELETE FROM c##course.audit_table;
/
BEGIN
    FOR i IN 1..2000 LOOP
        INSERT INTO c##course.audit_table 
        (
             sqlcode
            ,sqlerrm
            ,current_user
            ,dt
        ) VALUES (
             i
            ,'1'
            ,''
            ,SYSDATE
        );
    END LOOP;

END;

/
DELETE FROM c##course.audit_table;
/
DECLARE
    TYPE arr_type IS TABLE OF c##course.audit_table%ROWTYPE;
    items arr_type := arr_type();
BEGIN
    FOR i IN 1..2000 LOOP
        items.EXTEND;
        items(items.LAST).sqlcode := i;
        items(items.LAST).sqlerrm := 'a' || i;
        items(items.LAST).current_user := '';
        items(items.LAST).dt := SYSDATE;
    END LOOP;

    FORALL i IN items.FIRST..items.LAST
        INSERT INTO c##course.audit_table 
            VALUES items(i);

END;

/

