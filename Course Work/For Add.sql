SET SERVEROUTPUT ON
/

DECLARE
    credit_id number;
BEGIN
    c##course.pr_create_credit(
        'Сороколат Андрей Евгеньевич',
        TO_DATE('30.12.1977','DD.MM.YYYY'),
        100000,
        20,
        12
    );
    --DBMS_OUTPUT.PUT_LINE('client_id = ' || client_id);
END;
/




--select MAX(TO_NUMBER(REPLACE(num_dog,'2021' || '/','')))+1 from pr_credit Where num_dog like '2021' || '/%';

--select num_dog from pr_credit Where num_dog like '2021%';
--select * from c##course.pr_credit Where id_client = (select id from c##course.client where cl_name Like 'Сороколат%');

--select datepart(year,current_date),ADD_MONTHS(CURRENT_DATE,12),CURRENT_DATE from DUAL;



--select getdate() from DUAL;

--SELECT POWER(3,2) "Raised" FROM DUAL

--date_begin = 03.06.20
--date_end = 02.05.21
--SELECT * FROM c##course.plan_oper WHERE collection_id = 6446261209936 AND rownum < 2;
--delete from c##course.plan_oper WHERE collection_id = 6446261209936;
--SELECT user FROM DUAL;



