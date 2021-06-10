SELECT 
      a.collection_id
    , LTRIM(TO_CHAR((a.sum_vidano - NVL(b.sum_pogasheno,0)),'999999999999.00')) AS ostat_dolg
    
    FROM
    (
        SELECT
            SUM(f_summa) AS sum_vidano,
            collection_id
            FROM c##course.fact_oper
            WHERE
                f_date <= TO_DATE('10.10.2020','DD.MM.RRRR')
                AND
                type_oper = 'Выдача кредита'
            GROUP BY collection_id
    ) a
    LEFT JOIN 
    (
        SELECT
            SUM(f_summa) AS sum_pogasheno,
            collection_id
            FROM c##course.fact_oper
            WHERE
                f_date <= TO_DATE('10.10.2020','DD.MM.RRRR')
                AND
                type_oper = 'Погашение кредита'
            GROUP BY collection_id
   ) b
   ON (a.collection_id = b.collection_id)
;
