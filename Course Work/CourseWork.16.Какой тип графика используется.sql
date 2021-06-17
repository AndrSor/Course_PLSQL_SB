
-- Определим Какой Использузуется График

select
      SUM(p_summa)
    , COUNT(p_date)
    , p_date
    , collection_id
    FROM c##course.plan_oper
    WHERE
        type_oper = 'Погашение процентов'
        OR
        type_oper = 'Погашение кредита'
    GROUP BY
        collection_id,
        p_date
    ORDER BY collection_id;


-- Используется ануитентный график
