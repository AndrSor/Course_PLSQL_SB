


CREATE OR REPLACE TYPE c##course.report_row AS OBJECT
( 
      num_dog             varchar2(10)
    , cl_name             varchar2(100)
    , summa_dog           number
    , date_begin          date 
    , date_end            date
    , sum_vidano          number
    , ostat_dolg          number
    , need_pogash_percent number
);

CREATE OR REPLACE TYPE c##course.table_report AS TABLE OF c##course.report_row;



