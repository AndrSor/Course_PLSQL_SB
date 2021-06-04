------
------ Удаление таблицы FACT_OPER
------

DROP TABLE c##course.fact_oper;

------
------ Создание таблицы фактические операции
------

CREATE TABLE c##course.fact_oper (
    collection_id   NUMBER,
    f_date          DATE,
    f_summa         NUMBER(*,2),
    type_oper       VARCHAR2(50)
);

------
------ Создание индекса
------

CREATE INDEX c##course.idx_fact_oper_collection_id
    ON c##course.fact_oper (collection_id);

------
------ Добавление первичного ключа
------

ALTER TABLE c##course.fact_oper
    ADD
    ( 
        CONSTRAINT fact_oper_collection_id_fk
       		 FOREIGN KEY (collection_id)
                 REFERENCES c##course.pr_credit(collect_fact)

    );



