
------
------ Удаление таблицы PLAN_OPER
------

DROP TABLE c##course.plan_oper;

------
------ Создание таблицы плановые операции
------

CREATE TABLE c##course.plan_oper (
      collection_id   NUMBER
    , p_date          DATE
    , p_summa         NUMBER(*,2)
    , type_oper       VARCHAR2(50)
   
);

------
------ Создание индекса
------

CREATE INDEX c##course.idx_plan_oper_collection_id
    ON c##course.plan_oper (collection_id);

------
------ Добавление внешнего ключа
------


ALTER TABLE c##course.plan_oper
    ADD
    ( 
        CONSTRAINT plan_oper_collection_id_fk
       		 FOREIGN KEY (collection_id)
                 REFERENCES c##course.pr_credit(collect_plan)

    );



