CREATE OR REPLACE PROCEDURE c##course.write_audit
    (
         sql_code    IN NUMBER
        ,sql_errm    IN VARCHAR2
    )
IS

    PRAGMA AUTONOMOUS_TRANSACTION; 

BEGIN
    INSERT INTO c##course.audit_table
    (
         sqlcode
        ,sqlerrm
    ) VALUES (
         sql_code
        ,sql_errm
    );
    
    COMMIT;

END;

