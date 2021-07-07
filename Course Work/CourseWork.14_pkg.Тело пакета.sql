CREATE OR REPLACE PACKAGE BODY           pk_credit_report IS  

    FUNCTION fn_get_report (report_dt DATE)
        RETURN table_report
        IS
            result_table_report table_report;
            t_cursor report_cursor;

     BEGIN

      OPEN t_cursor FOR SELECT * 

        FROM
            (
            SELECT
                  dog.num_dog
                , cli.cl_name
                , dog.summa_dog
                , dog.date_begin
                , dog.date_end
                , sum_fact.sum_vidano - NVL(sum_fact.sum_pogasheno,0)
                , NVL(sum_pogasheno_percent_plan.sum_pogasheno_percent_plan,0) - NVL(sum_fact.sum_pogasheno_percent,0)
                
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
                ) sum_fact
                ON (dog.collect_fact = sum_fact.collection_id)
        
               LEFT JOIN 
               (
                    SELECT
                        SUM(p_summa) AS sum_pogasheno_percent_plan,
                        collection_id
                        FROM c##course.plan_oper
                        WHERE
                            p_date <= report_dt
                            AND
                            type_oper = 'Погашение процентов'
                        GROUP BY collection_id
               ) sum_pogasheno_percent_plan
               ON (dog.collect_plan = sum_pogasheno_percent_plan.collection_id)
        
               WHERE
                    dog.date_begin <= report_dt
               ORDER BY
                    dog.date_begin
            ) t

        ;

        FETCH t_cursor INTO result_table_report;
        CLOSE t_cursor;
        
        RETURN result_table_report;



    END fn_get_report;


    PROCEDURE pr_make_report (report_dt IN DATE)

    AS
        t NUMBER := 0;
    BEGIN

        t := 0;
/*

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
            SELECT * FROM fn_get_report (report_dt)
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
*/
    END pr_make_report;

END pk_credit_report;