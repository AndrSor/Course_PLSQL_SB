------
------ Необходимо выдать привелегии на создание ДИРЕКТЛОРИИ
-- GRANT CREATE ANY DIRECTORY TO c##cource;
------ Или делать от имени пользователя SYSTEM
------
------
------ https://oracle-patches.com/oracle/prof/%D0%B8%D1%81%D0%BF%D0%BE%D0%BB%D1%8C%D0%B7%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D0%B5-%D0%B2%D0%BD%D0%B5%D1%88%D0%BD%D0%B8%D1%85-%D1%82%D0%B0%D0%B1%D0%BB%D0%B8%D1%86-%D0%B4%D0%BB%D1%8F-%D0%B7%D0%B0%D0%B3%D1%80%D1%83%D0%B7%D0%BA%D0%B8-%D0%B4%D0%B0%D0%BD%D0%BD%D1%8B%D1%85
------ https://www.sql.ru/blogs/oracleandsql/2255
------ https://oracle-patches.com/oracle/prof/sql-loader-%D0%B7%D0%B0%D0%B3%D1%80%D1%83%D0%B7%D0%BA%D0%B0-%D0%B2-%D0%B1%D0%B0%D0%B7%D1%83-%D0%B4%D0%B0%D0%BD%D0%BD%D1%8B%D1%85-oracle-%D0%B8-%D0%BF%D1%80%D0%B5%D0%BE%D0%B1%D1%80%D0%B0%D0%B7%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D0%B5


DROP DIRECTORY directory_import;

CREATE DIRECTORY directory_import AS 'C:\Temp'; 

DROP TABLE c##course.organisations_external;

CREATE TABLE c##course.organisations_external (
      id  NUMBER
    , name VARCHAR(250)
)
ORGANIZATION EXTERNAL
(
    TYPE oracle_loader
    DEFAULT DIRECTORY directory_import
    ACCESS PARAMETERS 
    (
        RECORDS DELIMITED BY NEWLINE
        FIELDS TERMINATED BY ';'
        LDRTRIM 
        MISSING FIELD VALUES ARE NULL
    )
    LOCATION ('Organisations.csv')
)
REJECT LIMIT UNLIMITED;



INSERT INTO c##course.organisations SELECT * FROM c##course.organisations_external;

DROP TABLE c##course.organisations_external;


SELECT COUNT(*) AS row_amount FROM c##course.organisations;






