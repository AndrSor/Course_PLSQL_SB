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
    
    FUNCTION fn_get_report (report_dt DATE) RETURN table_report;
    
    PROCEDURE pr_make_report (report_dt IN DATE);
    
END pk_credit_report;
/


CREATE OR REPLACE PACKAGE BODY c##course.pk_credit_report AS

    FUNCTION fn_get_report (report_dt DATE)
        RETURN table_report
        IS
            result_table_report table_report := table_report();
     BEGIN

        FOR row_r IN (
                    SELECT
                          dog.num_dog                       AS num_dog
                        , cli.cl_name                       AS cl_name
                        , dog.summa_dog                     AS summa_dog
                        , dog.date_begin                    AS date_begin
                        , dog.date_end                      AS date_end
                        , fact.sum_vidano - NVL(fact.sum_pogasheno,0)
                                                            AS ostat_dolg
                        , NVL(plan.sum_pogasheno_percent,0) - NVL(fact.sum_pogasheno_percent,0)
                                                            AS need_pogash_percent
                        
                        FROM c##course.pr_credit dog
        
                        INNER JOIN
                            c##course.client cli
                            ON (dog.id_client = cli.id)
                
                        LEFT JOIN
                        (
                            SELECT
                                  collection_id
                                , SUM(CASE type_oper WHEN 'Выдача кредита'      THEN f_summa ELSE 0 END) AS sum_vidano
                                , SUM(CASE type_oper WHEN 'Погашение кредита'   THEN f_summa ELSE 0 END) AS sum_pogasheno
                                , SUM(CASE type_oper WHEN 'Погашение процентов' THEN f_summa ELSE 0 END) AS sum_pogasheno_percent
                                FROM c##course.fact_oper
                                WHERE
                                    f_date <= report_dt
                
                                GROUP BY collection_id
                        ) fact
                        ON (dog.collect_fact = fact.collection_id)
                
                       LEFT JOIN 
                       (
                            SELECT
                                SUM(p_summa) AS sum_pogasheno_percent,
                                collection_id
                                FROM c##course.plan_oper
                                WHERE
                                    type_oper = 'Погашение процентов'
                                GROUP BY collection_id
                       ) plan
                       ON (dog.collect_plan = plan.collection_id)
                
                       WHERE
                            dog.date_begin <= report_dt
                       ORDER BY
                            dog.date_begin
                    )
        LOOP

            --NULL;
            result_table_report.EXTEND;
            result_table_report(result_table_report.LAST).num_dog             := row_r.num_dog;
            result_table_report(result_table_report.LAST).cl_name             := row_r.cl_name;
            result_table_report(result_table_report.LAST).summa_dog           := row_r.summa_dog;
            result_table_report(result_table_report.LAST).date_begin          := row_r.date_begin;
            result_table_report(result_table_report.LAST).date_end            := row_r.date_end;
            result_table_report(result_table_report.LAST).ostat_dolg          := row_r.ostat_dolg;
            result_table_report(result_table_report.LAST).need_pogash_percent := row_r.need_pogash_percent;
            
    
        END LOOP;
        
        RETURN result_table_report;

    END fn_get_report;
    
    
    PROCEDURE pr_make_report (report_dt IN DATE) AS
        t NUMBER := 0;
        report_out table_report := table_report();
    BEGIN
        
        report_out := fn_get_report (TO_DATE('10.10.2020','DD.MM.YYYY'));
        
        
        DBMS_OUTPUT.PUT_LINE('<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="http://www.w3.org/TR/REC-html40">');
        DBMS_OUTPUT.PUT_LINE('<head>');
        DBMS_OUTPUT.PUT_LINE('<meta http-equiv=Content-Type content="text/html; charset=utf-8">');
        DBMS_OUTPUT.PUT_LINE('<meta name=ProgId content=Excel.Sheet>');
        DBMS_OUTPUT.PUT_LINE('<meta name=Generator content="Microsoft Excel 12">');
        DBMS_OUTPUT.PUT_LINE('<xml>');
        DBMS_OUTPUT.PUT_LINE('<x:ExcelWorkbook>');
        DBMS_OUTPUT.PUT_LINE('<x:RefModeR1C1/>');
        DBMS_OUTPUT.PUT_LINE('</x:ExcelWorkbook>');
        DBMS_OUTPUT.PUT_LINE('</xml>');
        DBMS_OUTPUT.PUT_LINE('</head>');
        DBMS_OUTPUT.PUT_LINE('<body>');
        DBMS_OUTPUT.PUT_LINE('<style>col{mso-width-source:auto}br{mso-data-placement:same-cell}td{font-size:8pt;vertical-align:bottom}</style>');
        DBMS_OUTPUT.PUT_LINE('<table>');
        DBMS_OUTPUT.PUT_LINE('<tr>');
        DBMS_OUTPUT.PUT_LINE('<td bgcolor="#DDDDFF" style="border-color:#000000;border-style:solid;border-width:.5pt .5pt .5pt .5pt">№ п.п.</td>');
        DBMS_OUTPUT.PUT_LINE('<td bgcolor="#DDDDFF" style="border-color:#000000;border-style:solid;border-width:.5pt .5pt .5pt  0pt">Номер договора</td>');
        DBMS_OUTPUT.PUT_LINE('<td bgcolor="#DDDDFF" style="border-color:#000000;border-style:solid;border-width:.5pt .5pt .5pt  0pt">ФИО клиента</td>');
        DBMS_OUTPUT.PUT_LINE('<td bgcolor="#DDDDFF" style="border-color:#000000;border-style:solid;border-width:.5pt .5pt .5pt  0pt">Сумма договора</td>');
        DBMS_OUTPUT.PUT_LINE('<td bgcolor="#DDDDFF" style="border-color:#000000;border-style:solid;border-width:.5pt .5pt .5pt  0pt">Дата начала договора</td>');
        DBMS_OUTPUT.PUT_LINE('<td bgcolor="#DDDDFF" style="border-color:#000000;border-style:solid;border-width:.5pt .5pt .5pt  0pt">Дата окончания договора</td>');
        DBMS_OUTPUT.PUT_LINE('<td bgcolor="#DDDDFF" style="border-color:#000000;border-style:solid;border-width:.5pt .5pt .5pt  0pt">Остаток ссудной задолженности</td>');
        DBMS_OUTPUT.PUT_LINE('<td bgcolor="#DDDDFF" style="border-color:#000000;border-style:solid;border-width:.5pt .5pt .5pt  0pt">Сумма предстоящих процентов к погашению</td>');
        DBMS_OUTPUT.PUT_LINE('</tr>');
          
        FOR i IN (
            SELECT * FROM TABLE(report_out)
        ) LOOP
        
        t := t + 1;
        DBMS_OUTPUT.PUT_LINE('<tr>');
        DBMS_OUTPUT.PUT_LINE('<td style="border-color:#000000;border-style:solid;border-width:.5pt .5pt .5pt .5pt;text-align:right">' || t || '</td>');
        DBMS_OUTPUT.PUT_LINE('<td style="border-color:#000000;border-style:solid;border-width:.5pt .5pt .5pt  0pt">' || i.num_dog || '</td>');
        DBMS_OUTPUT.PUT_LINE('<td style="border-color:#000000;border-style:solid;border-width:.5pt .5pt .5pt  0pt">' || i.cl_name || '</td>');
        DBMS_OUTPUT.PUT_LINE('<td style="border-color:#000000;border-style:solid;border-width:.5pt .5pt .5pt  0pt;mso-number-format:''Standard'';text-align:right">' || i.summa_dog || '</td>');
        DBMS_OUTPUT.PUT_LINE('<td style="border-color:#000000;border-style:solid;border-width:.5pt .5pt .5pt  0pt;text-align:right">' || i.date_begin || '</td>');
        DBMS_OUTPUT.PUT_LINE('<td style="border-color:#000000;border-style:solid;border-width:.5pt .5pt .5pt  0pt;text-align:right">'  || i.date_end ||  '</td>');
        DBMS_OUTPUT.PUT_LINE('<td style="border-color:#000000;border-style:solid;border-width:.5pt .5pt .5pt  0pt;mso-number-format:''Standard'';text-align:right">' || i.ostat_dolg || '</td>');
        DBMS_OUTPUT.PUT_LINE('<td style="border-color:#000000;border-style:solid;border-width:.5pt .5pt .5pt  0pt;mso-number-format:''Standard'';text-align:right">' || i.need_pogash_percent || '</td>');
        DBMS_OUTPUT.PUT_LINE('</tr>');
        
        END LOOP;
    
        DBMS_OUTPUT.PUT_LINE('</table>');
        DBMS_OUTPUT.PUT_LINE('</table>');
        DBMS_OUTPUT.PUT_LINE('</html>');
    
    END pr_make_report;
    
END pk_credit_report;
/

/
SET SERVEROUTPUT ON
/
/*
-- Тест функции
DECLARE
    report_out c##course.pk_credit_report.table_report :=c##course.pk_credit_report.table_report();
BEGIN

    report_out :=  c##course.pk_credit_report.fn_get_report (TO_DATE('10.10.2020','DD.MM.YYYY'));


        DBMS_OUTPUT.PUT_LINE(
               RPAD('ДОГОВОР',10,' ')
            || RPAD('КЛИЕНТ',40,' ')
            || RPAD('КРЕДИТ',15,' ')
            || RPAD('НАЧАЛО',10,' ')
            || RPAD('КОНЕЦ',10,' ')
            || RPAD('ЗАДОЛЖЕННОСТЬ',15,' ')
            || RPAD('ЗАДОЛЖЕННОСТЬ %',15,' ')
        );


    FOR i IN 1..report_out.COUNT LOOP
        
        DBMS_OUTPUT.PUT_LINE(
               RPAD(report_out(i).num_dog,10,' ')
            || RPAD(report_out(i).cl_name,40,' ')
            || RPAD(TO_CHAR(report_out(i).summa_dog,'9999990.99'),15,' ')
            || RPAD(report_out(i).date_begin,10,' ')
            || RPAD(report_out(i).date_end,10,' ')
            || RPAD(TO_CHAR(report_out(i).ostat_dolg,'9999990.00'),15,' ')
            || RPAD(TO_CHAR(report_out(i).need_pogash_percent,'9999990.99'),15,' ')
        );
        
    END LOOP;
END;
*/
/


SET ECHO OFF
SET VERIFY OFF
SET SERVEROUTPUT ON

ACCEPT dt DATE FORMAT 'dd.mm.yyyy' PROMPT 'Введите дату отчета:  ';

DEFINE spool_file = 'c:\Temp\&dt..xls';
SPOOL &spool_file

EXECUTE c##course.pk_credit_report.pr_make_report (TO_DATE('&dt','DD.MM.YYYY'));

SPOOL OFF


