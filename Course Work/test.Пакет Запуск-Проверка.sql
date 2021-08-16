DECLARE

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
    
    t_report table_report := table_report();

BEGIN

    --t_report := c##course.fn_get_report ( TO_DATE('10.10.2020','DD.MM.YYYY'));

    --FOR i IN (
    --    SELECT * FROM c##course.pk_credit_report.fn_get_report (TO_DATE('10.10.2020','DD.MM.YYYY'))
    --) LOOP
    
    --    NULL;
        
    
    --END LOOP ;


END;


/

--SELECT * FROM TABLE(c##course.pk_credit_report.fn_get_report (TO_DATE('10.10.2020','DD.MM.YYYY'))) t;
