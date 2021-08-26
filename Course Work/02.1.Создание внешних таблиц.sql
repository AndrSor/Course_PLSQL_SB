------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------

------ Выполняется с привелегиями CREATE ANY DIRECTORY/ DROP ANY DIRECTORY.
------ GRANT CREATE ANY DIRECTORY, DROP ANY DIRECTORY TO c##course;

------ 1.5.Создание объекта "Директория импорта"

DROP DIRECTORY directory_import;
CREATE DIRECTORY directory_import AS 'C:\Temp'; 
DROP DIRECTORY importlog;
CREATE DIRECTORY importlog AS 'C:\Temp\Importlog'; 

------ 1.6.Создание Внешних таблиц

DROP TABLE c##course.client_external;

-- CLIENT_EXTERNAL

CREATE TABLE c##course.client_external (
       ID          NUMBER
     , CL_NAME     VARCHAR2(100)
     , DATE_BIRTH  DATE
)
ORGANIZATION EXTERNAL
(
    TYPE oracle_loader
    DEFAULT DIRECTORY directory_import
    ACCESS PARAMETERS 
    (
        RECORDS DELIMITED BY NEWLINE
        BADFILE     'IMPORTLOG':'client.bad'
        DISCARDFILE 'IMPORTLOG':'client.dis'
        LOGFILE     'IMPORTLOG':'client.log'
        FIELDS TERMINATED BY ';'
        (
              ID         
            , CL_NAME    
            , DATE_BIRTH CHAR(10) DATE_FORMAT DATE MASK "dd/mm/yyyy"
        )
    )
    LOCATION ('client.csv')
)
REJECT LIMIT UNLIMITED;

-- PR_CREDIT

DROP TABLE c##course.pr_credit_external;

CREATE TABLE c##course.pr_credit_external (
      id              NUMBER
    , num_dog         VARCHAR2(10)
    , summa_dog       VARCHAR2(10)
    , date_begin      DATE
    , date_end        DATE
    , id_client       NUMBER
    , collect_plan    NUMBER
    , collect_fact    NUMBER

)
ORGANIZATION EXTERNAL
(
    TYPE oracle_loader
    DEFAULT DIRECTORY directory_import
    ACCESS PARAMETERS 
    (
        RECORDS DELIMITED BY NEWLINE
        BADFILE     'IMPORTLOG':'pr_credit.bad'
        DISCARDFILE 'IMPORTLOG':'pr_credit.dis'
        LOGFILE     'IMPORTLOG':'pr_credit.log'
        FIELDS TERMINATED BY ';'
        (
              ID              
            , NUM_DOG         
            , SUMMA_DOG       
            , DATE_BEGIN      CHAR(10) DATE_FORMAT DATE MASK "dd.mm.yyyy"
            , DATE_END        CHAR(10) DATE_FORMAT DATE MASK "dd.mm.yyyy"
            , ID_CLIENT       
            , COLLECT_PLAN    
            , COLLECT_FACT
        )
    )
    LOCATION ('pr_credit.csv')
)
REJECT LIMIT UNLIMITED;

-- PLAN_OPER

DROP TABLE c##course.plan_oper_external;

CREATE TABLE c##course.plan_oper_external (
      collection_id   NUMBER
    , p_date          DATE
    , p_summa         VARCHAR2(10)
    , type_oper       VARCHAR2(50)
)
ORGANIZATION EXTERNAL
(
    TYPE oracle_loader
    DEFAULT DIRECTORY directory_import
    ACCESS PARAMETERS 
    (
        RECORDS DELIMITED BY NEWLINE
        BADFILE     'IMPORTLOG':'plan_oper.bad'
        DISCARDFILE 'IMPORTLOG':'plan_oper.dis'
        LOGFILE     'IMPORTLOG':'plan_oper.log'
        FIELDS TERMINATED BY ';'
        (
              COLLECTION_ID
            , P_DATE          CHAR(10) DATE_FORMAT DATE MASK "dd.mm.yyyy"
            , P_SUMMA
            , TYPE_OPER
        )
    )
    LOCATION ('plan_oper.csv')
)
REJECT LIMIT UNLIMITED;

-- FACT_OPER

DROP TABLE c##course.fact_oper_external;

CREATE TABLE c##course.fact_oper_external (
      collection_id   NUMBER
    , f_date          DATE
    , f_summa         VARCHAR2(10)
    , type_oper       VARCHAR2(50)
)
ORGANIZATION EXTERNAL
(
    TYPE oracle_loader
    DEFAULT DIRECTORY directory_import
    ACCESS PARAMETERS 
    (
        RECORDS DELIMITED BY NEWLINE
        BADFILE     'IMPORTLOG':'fact_oper.bad'
        DISCARDFILE 'IMPORTLOG':'fact_oper.dis'
        LOGFILE     'IMPORTLOG':'fact_oper.log'
        FIELDS TERMINATED BY ';'
        (
              COLLECTION_ID
            , F_DATE          CHAR(10) DATE_FORMAT DATE MASK "dd.mm.yyyy"
            , F_SUMMA
            , TYPE_OPER
        )
    )
    LOCATION ('fact_oper.csv')
)
REJECT LIMIT UNLIMITED;

-- TEST

SELECT
      (SELECT COUNT(*) FROM c##course.client_external)      AS row_amount_in_client_external 
    , (SELECT COUNT(*) FROM c##course.pr_credit_external)   AS row_amount_in_pr_cxredit_external  
    , (SELECT COUNT(*) FROM c##course.plan_oper_external)   AS row_amount_in_plan_oper_external   
    , (SELECT COUNT(*) FROM c##course.fact_oper_external)   AS row_amount_in_fact_oper_external   
    FROM DUAL;





