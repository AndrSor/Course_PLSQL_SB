CREATE OR REPLACE PACKAGE c##course.pk_credit_report AS   
    TYPE report_row IS RECORD
    ( 
          num_dog             varchar2(10)
        , cl_name             varchar2(100)
        , summa_dog           number
        , date_begin          date 
        , date_end            date
        , ostat_dolg          number
        , need_pogash_percent number
    );

    TYPE table_report IS TABLE OF report_row;
    
    TYPE report_cursor IS REF CURSOR RETURN report_row;

    FUNCTION fn_get_report (report_dt DATE) RETURN table_report;
    
    PROCEDURE pr_make_report (report_dt IN DATE);
    
END pk_credit_report;
/

