------
------ Удаление таблицы PR_CREDIT
------

DROP TABLE c##course.pr_credit;

------
------ Создание таблицы кредитные договоры
------

CREATE TABLE c##course.pr_credit (
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

CREATE UNIQUE INDEX c##course.idx_pr_credit_id
    ON c##course.pr_credit (id);

------
------ Добавление первичного и внешних ключей
------


ALTER TABLE c##course.pr_credit
    ADD
    ( 
          CONSTRAINT    pr_credit_id_pk
                            PRIMARY KEY (id)
        , CONSTRAINT    pr_credit_id_client_fk
                            FOREIGN KEY (id_client)
                                REFERENCES c##course.client(id)

    );



