CREATE OR REPLACE PROCEDURE c##course.pr_make_report (report_dt IN DATE)

AS
    t NUMBER := 0;
BEGIN

    t := 0;
    
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
        SELECT * FROM c##course.fn_get_report (report_dt)
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

END;

    

/


SET ECHO OFF
SET VERIFY OFF
SET SERVEROUTPUT ON

ACCEPT dt DATE FORMAT 'dd.mm.yyyy' PROMPT 'Введите дату отчета:  ';

DEFINE spool_file = 'c:\Temp\&dt..xls';
SPOOL &spool_file

BEGIN

    FOR i IN (select c##course.fn_make_report (to_date('&dt','DD.MM.YYYY')) AS st FROM dual) LOOP
        DBMS_OUTPUT.PUT_LINE(i.st);
    END LOOP;

END;
/

SPOOL OFF
