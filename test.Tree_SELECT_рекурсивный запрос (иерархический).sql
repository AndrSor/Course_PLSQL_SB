CREATE TABLE c##course.test_tree
(
    id      NUMBER,
    pid     NUMBER,
    title   VARCHAR2(100)
);

INSERT INTO c##course.test_tree VALUES (   1,  NULL,   'Россия');
INSERT INTO c##course.test_tree VALUES (   2,  1,      'Воронеж');
INSERT INTO c##course.test_tree VALUES (   3,  2,      'ООО "Рога и копыта"');
INSERT INTO c##course.test_tree VALUES (   4,  1,      'Москва');
INSERT INTO c##course.test_tree VALUES (   5,  1,      'Лиски');
INSERT INTO c##course.test_tree VALUES (   6,  3,      'Главный офис');
INSERT INTO c##course.test_tree VALUES (   7,  3,      'Офис 1');
INSERT INTO c##course.test_tree VALUES (   8,  3,      'Офис 2');
INSERT INTO c##course.test_tree VALUES (   9,  8,      'Сервер 1');
INSERT INTO c##course.test_tree VALUES (  10,  5,      'ЛискиПресс');

SELECT
    ROWNUM,
    LPAD(' ',LEVEL*4) ||  title as name
    FROM c##course.test_tree
    START WITH pid IS NULL
    CONNECT BY PRIOR id = pid
    ORDER SIBLINGS BY title
;
    