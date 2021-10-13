CLEAR SCREEN

DECLARE
    ref_cursor              SYS_REFCURSOR;

    TYPE report_row_type IS RECORD
    ( 
          num_dog             varchar2(10)
        , cl_name             varchar2(100)
        , summ_dog            number
        , date_begin          date 
        , date_end            date
        , ostat_dolg          number
        , need_pogash_percent number
    );

    report_row report_row_type;

--    num_dog                 VARCHAR(100);
--    cl_name                 VARCHAR2(100);
--    summ_dog                NUMBER;
--    date_begin              DATE;
--    date_end                DATE;
--    ostat_dolg              NUMBER;
--    need_pogash_percent     NUMBER;

    state_cur BOOLEAN;
    
BEGIN

    c##course.pk_credit_report2.get_report (report_dt => TO_DATE('10.10.2020','DD.MM.YYYY'),r_c => ref_cursor);
    
   LOOP
        FETCH ref_cursor INTO
--             num_dog
--            ,cl_name
--            ,summ_dog
--            ,date_begin
--            ,date_end
--            ,ostat_dolg
--            ,need_pogash_percent
report_row
        ;
        EXIT WHEN ref_cursor%NOTFOUND; 

        DBMS_OUTPUT.PUT_LINE(
               RPAD(report_row.num_dog,10,' ')
            || RPAD(c##course.split.get(report_row.cl_name,' ',1)||' '||c##course.split.get(report_row.cl_name,' ',2)||' '||c##course.split.get(report_row.cl_name,' ',0),40,' ')
            || RPAD(TO_CHAR(report_row.summ_dog,'9999990.99'),15,' ')
            || RPAD(report_row.date_begin,10,' ')
            || RPAD(report_row.date_end,10,' ')
            || RPAD(TO_CHAR(report_row.ostat_dolg,'9999990.00'),15,' ')
            || RPAD(TO_CHAR(report_row.need_pogash_percent,'9999990.99'),15,' ')
        );

            
--        DBMS_OUTPUT.PUT_LINE(
--               RPAD(num_dog,10,' ')
--            || RPAD(c##course.split.get(cl_name,' ',1)||' '||c##course.split.get(cl_name,' ',2)||' '||c##course.split.get(cl_name,' ',0),40,' ')
--            || RPAD(TO_CHAR(summ_dog,'9999990.99'),15,' ')
--            || RPAD(date_begin,10,' ')
--            || RPAD(date_end,10,' ')
--            || RPAD(TO_CHAR(ostat_dolg,'9999990.00'),15,' ')
--            || RPAD(TO_CHAR(need_pogash_percent,'9999990.99'),15,' ')
--        );
            
       END LOOP;
       
       CLOSE ref_cursor;
        
END;


