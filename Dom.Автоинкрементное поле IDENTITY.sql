ALTER SESSION SET CURRENT_SCHEMA=c##course;

DROP TABLE test1;

CREATE TABLE test1 (
     id             NUMBER GENERATED ALWAYS AS IDENTITY
    ,acct           NUMBER
    ,name           VARCHAR(100));
    
INSERT INTO test1 (acct,name) VALUES (1,'Андрей');
INSERT INTO test1 (acct,name) VALUES (5,'Илья');

SELECT * FROM test1;

DROP TABLE test1;