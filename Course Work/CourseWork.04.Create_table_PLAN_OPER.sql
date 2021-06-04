ALTER SESSION SET CURRENT_SCHEMA=c##course;

------
------ Удаление таблицы PLAN_OPER
------

DROP TABLE plan_oper;

------
------ Создание таблицы плановые операции
------

CREATE TABLE plan_oper (
      collection_id   NUMBER
    , p_date          DATE
    , p_summa         NUMBER(*,2)
    , type_oper       VARCHAR2(50)
   
);

------
------ Создание индекса
------

CREATE INDEX idx_plan_oper_collection_id
    ON plan_oper (collection_id);

------
------ Добавление внешнего ключа
------


ALTER TABLE plan_oper
    ADD
    ( 
        CONSTRAINT plan_oper_collection_id_fk
       		 FOREIGN KEY (collection_id)
                 REFERENCES pr_credit(collect_plan)

    );



