DROP TABLE c##hr.people_source;
DROP TABLE c##hr.people_target;

CREATE TABLE c##hr.people_source ( 
    person_id  INTEGER NOT NULL PRIMARY KEY, 
    first_name VARCHAR2(20) NOT NULL, 
    last_name  VARCHAR2(20) NOT NULL, 
    title      VARCHAR2(10) NOT NULL 
);

CREATE TABLE c##hr.people_target ( 
    person_id  INTEGER NOT NULL PRIMARY KEY, 
    first_name VARCHAR2(20) NOT NULL, 
    last_name  VARCHAR2(20) NOT NULL, 
    title      VARCHAR2(10) NOT NULL 
);

INSERT INTO c##hr.people_target VALUES (1, 'John', 'Smith', 'Mr');
INSERT INTO c##hr.people_target VALUES (2, 'alice', 'jones', 'Mrs');

INSERT INTO c##hr.people_source VALUES (2, 'Alice', 'Jones', 'Mrs.');
INSERT INTO c##hr.people_source VALUES (3, 'Jane', 'Doe', 'Miss');
INSERT INTO c##hr.people_source VALUES (4, 'Dave', 'Brown', 'Mr');

COMMIT;

SELECT * FROM c##hr.people_target;
SELECT * FROM c##hr.people_source;

------
------
------

MERGE INTO c##hr.people_target pt 
    USING c##hr.people_source ps 
        ON (pt.person_id = ps.person_id) 
    WHEN MATCHED THEN UPDATE 
        SET
              pt.first_name = ps.first_name
            , pt.last_name = ps.last_name
            , pt.title = ps.title;
      
SELECT * FROM c##hr.people_target;

ROLLBACK;


MERGE INTO c##hr.people_target pt 
    USING c##hr.people_source ps 
        ON (pt.person_id = ps.person_id) 
    WHEN NOT MATCHED THEN
        INSERT 
            (
                pt.person_id
              , pt.first_name
              , pt.last_name
              , pt.title
            ) 
            VALUES
            (
                ps.person_id
              , ps.first_name
              , ps.last_name
              , ps.title
            );
  
SELECT * FROM c##hr.people_target;

ROLLBACK;

------
------
------

MERGE INTO c##hr.people_target pt 
    USING c##hr.people_source ps
        ON (pt.person_id = ps.person_id) 
    WHEN MATCHED THEN UPDATE 
        SET
          pt.first_name = ps.first_name
        , pt.last_name  = ps.last_name
        , pt.title      = ps.title 
    DELETE WHERE pt.title  = 'Mrs.' 
    WHEN NOT MATCHED THEN
        INSERT 
            (
                  pt.person_id
                , pt.first_name
                , pt.last_name
                , pt.title
            ) 
            VALUES
            (
                  ps.person_id
                , ps.first_name
                , ps.last_name
                , ps.title
            ) 
    WHERE ps.title = 'Mr';
  
SELECT * FROM c##hr.people_target;

ROLLBACK;
