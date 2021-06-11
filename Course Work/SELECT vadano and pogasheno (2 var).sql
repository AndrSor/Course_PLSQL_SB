
        SELECT
            SUM(f_summa) AS summ,
            collection_id,
            type_oper
            FROM c##course.fact_oper
            WHERE
                f_date <= TO_DATE('10.10.2020','DD.MM.RRRR')
            GROUP BY collection_id,type_oper

