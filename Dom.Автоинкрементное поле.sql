ALTER SESSION SET CURRENT_SCHEMA=c##course;

------ Последовательность

CREATE sequence sq_test;

DROP TABLE test;

CREATE TABLE test (
    test_id NUMBER(38)
  , code VARCHAR2(16)
  , constraint pk_test primary key (test_id)
);

INSERT INTO test (test_id, code) VALUES (sq_test.NEXTVAL, 'One');

SELECT * FROM test;

DROP TABLE test;