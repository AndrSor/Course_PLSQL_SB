DROP TABLE c##course.t1;

CREATE TABLE c##course.t1
(
    id int
    ,name varchar2(8)
    ,status varchar2(8)
)
;
INSERT INTO c##course.t1 SELECT 1,'name1','deleted' FROM dual;
INSERT INTO c##course.t1 SELECT 1,'name2','ndeleted' FROM dual;
INSERT INTO c##course.t1 SELECT 1,'name1','ddeleted' FROM dual;
INSERT INTO c##course.t1 SELECT 1,'name1','deleted' FROM dual;
INSERT INTO c##course.t1 SELECT 1,'name1','deleted' FROM dual;

SELECT * FROM c##course.t1;


/

DROP TYPE c##course.arrtype;
DROP TYPE c##course.rectype;
/

CREATE OR REPLACE TYPE c##course.rectype IS OBJECT (id int, name varchar2 (8), status varchar2 (8))
/

CREATE OR REPLACE TYPE c##course.arrtype IS TABLE OF rectype 
/

DROP FUNCTION c##course.func;
/

CREATE OR REPLACE FUNCTION c##course.func (name varchar2) RETURN c##course.arrtype PIPELINED IS
    arr c##course.arrtype;
begin
    SELECT c##course.rectype (id, name, status) BULK COLLECT INTO arr 
    FROM t1
    WHERE name = c##course.func.name;
    FOR i IN 1..arr.count LOOP
        PIPE ROW (c##course.rectype (arr(i).id, arr(i).name, arr(i).status)); 
    END LOOP;     
    RETURN;
end;
/

select * from c##course.func ('name1');