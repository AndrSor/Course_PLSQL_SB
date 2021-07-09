------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------

------ Удаление таблицы CLIENTS

DROP TABLE c##course.client;

------ Создание таблицы клиенты (физ. лица)

CREATE TABLE c##course.client (
    id          NUMBER,
    cl_name     VARCHAR2(100),
    date_birth  DATE
);

------ Создание индекса

CREATE UNIQUE INDEX c##course.idx_client_id
    ON c##course.client (id);

------ Добавление первичного ключа

ALTER TABLE c##course.client
    ADD
    ( 
        CONSTRAINT client_id_pk
       		 PRIMARY KEY (id)
    );





------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------


------ Удаление таблицы PR_CREDIT

DROP TABLE c##course.pr_credit;

------ Создание таблицы кредитные договоры

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

------ Создание индексов

CREATE UNIQUE INDEX c##course.idx_pr_credit_id
    ON c##course.pr_credit (id);

------ Добавление первичного и внешних ключей

ALTER TABLE c##course.pr_credit
    ADD
    ( 
          CONSTRAINT    pr_credit_id_pk
                            PRIMARY KEY (id)
        , CONSTRAINT    pr_credit_id_client_fk
                            FOREIGN KEY (id_client)
                                REFERENCES c##course.client(id)

    );





------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------


------ Удаление таблицы FACT_OPER

DROP TABLE c##course.fact_oper;

------ Создание таблицы фактические операции

CREATE TABLE c##course.fact_oper (
    collection_id   NUMBER,
    f_date          DATE,
    f_summa         NUMBER(*,2),
    type_oper       VARCHAR2(50)
);

------ Создание индекса

CREATE INDEX c##course.idx_fact_oper_collection_id
    ON c##course.fact_oper (collection_id);

------ Добавление первичного ключа

ALTER TABLE c##course.fact_oper
    ADD
    ( 
        CONSTRAINT fact_oper_collection_id_fk
       		 FOREIGN KEY (collection_id)
                 REFERENCES c##course.pr_credit(collect_fact)

    );




------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------


------ Удаление таблицы PLAN_OPER

DROP TABLE c##course.plan_oper;

------ Создание таблицы плановые операции

CREATE TABLE c##course.plan_oper (
      collection_id   NUMBER
    , p_date          DATE
    , p_summa         NUMBER(*,2)
    , type_oper       VARCHAR2(50)
   
);

------ Создание индекса

CREATE INDEX c##course.idx_plan_oper_collection_id
    ON c##course.plan_oper (collection_id);

------ Добавление внешнего ключа


ALTER TABLE c##course.plan_oper
    ADD
    ( 
        CONSTRAINT plan_oper_collection_id_fk
       		 FOREIGN KEY (collection_id)
                 REFERENCES c##course.pr_credit(collect_plan)

    );



------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------





-- Удаление таблицы AUDIT_TABLE

DROP TABLE c##course.audit_table;
/

-- Создание таблицы плановые операции


CREATE TABLE c##course.audit_table (
      sqlcode             NUMBER
    , sqlerrm             VARCHAR2(200)
    , current_user        VARCHAR2(200)     DEFAULT USER
    , dt                  TIMESTAMP         DEFAULT SYSDATE
   
);
/

-- Удаление таблицы отчетов

DROP TABLE c##course.reports;
/

-- Создание таблицы отчетов

CREATE TABLE c##course.reports
( 
          num_dog             varchar2(10)
        , cl_name             varchar2(100)
        , summa_dog           number
        , date_begin          date 
        , date_end            date
        , ostat_dolg          number
        , need_pogash_percent number
        , report_dt           date
 );