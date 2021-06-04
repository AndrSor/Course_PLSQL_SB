ALTER SESSION SET CURRENT_SCHEMA=c##course;

------
------ Удаление таблицы PR_CREDIT
------

DROP TABLE pr_credit;

------
------ Создание таблицы кредитные договоры
------

CREATE TABLE pr_credit (
      id              NUMBER
    , num_dog         VARCHAR2(10)
    , summa_dog       NUMBER(*,2)
    , date_begin      DATE
    , date_end        DATE
    , id_client       NUMBER
    , collect_plan    NUMBER
    , collect_fact    NUMBER
    , CONSTRAINT      collect_plan_unique   UNIQUE (collect_plan)
    , CONSTRAINT      collect_fact_unique   UNIQUE (collect_fact)
    
);

------
------ Создание индексов
------

CREATE UNIQUE INDEX idx_pr_credit_id
    ON pr_credit (id);
--CREATE UNIQUE INDEX idx_pr_credit_collect_plan
--    ON pr_credit (collect_plan);
--CREATE UNIQUE INDEX idx_pr_credit_collect_fact
--    ON pr_credit (collect_fact);


------
------ Добавление первичного и внешних ключей
------


ALTER TABLE pr_credit
    ADD
    ( 
          CONSTRAINT    pr_credit_id_pk
                            PRIMARY KEY (id,collect_plan,collect_fact)
        , CONSTRAINT    pr_credit_id_client_fk
                            FOREIGN KEY (id_client)
                                REFERENCES client(id)

    );



