ALTER SESSION SET CURRENT_SCHEMA=c##course;

------
------ Удаление таблицы FACT_OPER
------

DROP TABLE fact_oper;

------
------ Создание таблицы фактические операции
------

CREATE TABLE fact_oper (
    collection_id   NUMBER,
    f_date          DATE,
    f_summa         NUMBER(*,2),
    type_oper       VARCHAR2(50)
);

------
------ Создание индекса
------

CREATE INDEX idx_fact_oper_collection_id
    ON fact_oper (collection_id);

------
------ Добавление первичного ключа
------

ALTER TABLE fact_oper
    ADD
    ( 
        CONSTRAINT fact_oper_collection_id_fk
       		 FOREIGN KEY (collection_id)
                 REFERENCES pr_credit(collect_fact)

    );



