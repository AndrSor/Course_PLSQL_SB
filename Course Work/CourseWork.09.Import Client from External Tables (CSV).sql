
DROP DIRECTORY directory_import;

CREATE DIRECTORY directory_import AS 'C:\Temp'; 

DROP TABLE c##course.client_external;

CREATE TABLE c##course.client_external (
       ID          NUMBER
     , CL_NAME     VARCHAR2(100)
     , DATE_BIRTH  DATE
)
ORGANIZATION EXTERNAL
(
    TYPE oracle_loader
    DEFAULT DIRECTORY directory_import
    ACCESS PARAMETERS 
    (
        RECORDS DELIMITED BY NEWLINE
        FIELDS TERMINATED BY ';'
        (
              ID         CHAR(15)
            , CL_NAME    CHAR(100)
            , DATE_BIRTH CHAR(10) DATE_FORMAT DATE MASK "dd/mm/yyyy"
        )
    )
    LOCATION ('client.csv')
)
REJECT LIMIT UNLIMITED;



REM INSERT INTO c##course.organisations SELECT * FROM c##course.organisations_external;

REM DROP TABLE c##course.organisations_external;


REM SELECT COUNT(*) AS row_amount FROM c##course.organisations;






