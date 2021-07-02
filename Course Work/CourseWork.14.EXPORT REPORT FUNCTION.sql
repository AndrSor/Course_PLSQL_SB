CREATE OR REPLACE FUNCTION c##course.fn_make_report (report_dt DATE)
    RETURN clob
AS
    st CLOB := '';
    t NUMBER := 0;
BEGIN

    t := 0;
    
    st := st || '<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="http://www.w3.org/TR/REC-html40">';
    st := st || '<head>';
    st := st || '<meta http-equiv=Content-Type content="text/html; charset=utf-8">';
    st := st || '<meta name=ProgId content=Excel.Sheet>';
    st := st || '<meta name=Generator content="Microsoft Excel 12">';
    st := st || '<xml>';
    st := st || '<x:ExcelWorkbook>';
    st := st || '<x:RefModeR1C1/>';
    st := st || '</x:ExcelWorkbook>';
    st := st || '</xml>';
    st := st || '</head>';
    st := st || '<body>';
    st := st || '<style>col{mso-width-source:auto}br{mso-data-placement:same-cell}td{font-size:8pt;vertical-align:bottom}</style>';
    st := st || '<table>';
    st := st || '<tr>';
    st := st || '<td bgcolor="#DDDDFF" style="border-color:#000000;border-style:solid;border-width:.5pt .5pt .5pt .5pt">№ п.п.</td>';
    st := st || '<td bgcolor="#DDDDFF" style="border-color:#000000;border-style:solid;border-width:.5pt .5pt .5pt  0pt">Номер договора</td>';
    st := st || '<td bgcolor="#DDDDFF" style="border-color:#000000;border-style:solid;border-width:.5pt .5pt .5pt  0pt">ФИО клиента</td>';
    st := st || '<td bgcolor="#DDDDFF" style="border-color:#000000;border-style:solid;border-width:.5pt .5pt .5pt  0pt">Сумма договора</td>';
    st := st || '<td bgcolor="#DDDDFF" style="border-color:#000000;border-style:solid;border-width:.5pt .5pt .5pt  0pt">Дата начала договора</td>';
    st := st || '<td bgcolor="#DDDDFF" style="border-color:#000000;border-style:solid;border-width:.5pt .5pt .5pt  0pt">Дата окончания договора</td>';
    st := st || '<td bgcolor="#DDDDFF" style="border-color:#000000;border-style:solid;border-width:.5pt .5pt .5pt  0pt">Остаток ссудной задолженности</td>';
    st := st || '<td bgcolor="#DDDDFF" style="border-color:#000000;border-style:solid;border-width:.5pt .5pt .5pt  0pt">Сумма предстоящих процентов к погашению</td>';
    st := st || '</tr>';
      
    FOR i IN (
        SELECT * FROM c##course.fn_get_report (report_dt)
    ) LOOP
    
    t := t + 1;
    st := st || '<tr>';
    st := st || '<td style="border-color:#000000;border-style:solid;border-width:.5pt .5pt .5pt .5pt;text-align:right">' || t || '</td>';
    st := st || '<td style="border-color:#000000;border-style:solid;border-width:.5pt .5pt .5pt  0pt">' || i.num_dog || '</td>';
    st := st || '<td style="border-color:#000000;border-style:solid;border-width:.5pt .5pt .5pt  0pt">' || i.cl_name || '</td>';
    st := st || '<td style="border-color:#000000;border-style:solid;border-width:.5pt .5pt .5pt  0pt;mso-number-format:''Standard'';text-align:right">' || i.summa_dog || '</td>';
    st := st || '<td style="border-color:#000000;border-style:solid;border-width:.5pt .5pt .5pt  0pt;text-align:right">' || i.date_begin || '</td>';
    st := st || '<td style="border-color:#000000;border-style:solid;border-width:.5pt .5pt .5pt  0pt;text-align:right">'  || i.date_end ||  '</td>';
    st := st || '<td style="border-color:#000000;border-style:solid;border-width:.5pt .5pt .5pt  0pt;mso-number-format:''Standard'';text-align:right">' || i.ostat_dolg || '</td>';
    st := st || '<td style="border-color:#000000;border-style:solid;border-width:.5pt .5pt .5pt  0pt;mso-number-format:''Standard'';text-align:right">' || i.need_pogash_percent || '</td>';
    st := st || '</tr>';
    
    END LOOP;

    st := st || '</table>';
    st := st || '</table>';
    st := st || '</html>';

    RETURN st;    

END;

    

