--
-- Удаление таблицы AUDIT_TABLE
--
DROP TABLE c##course.audit_table;
/
--
-- Создание таблицы плановые операции
--

CREATE TABLE c##course.audit_table (
      sqlcode             NUMBER
    , sqlerrm             VARCHAR2(200)
    , current_user        VARCHAR2(200)     DEFAULT USER
    , dt                  TIMESTAMP         DEFAULT SYSDATE
   
);
/

--
-- Удаление таблицы отчетов
--
DROP TABLE c##course.reports;
/
--
-- Создание таблицы отчетов
--



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