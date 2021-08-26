/*
|
| График платежей
|
*/

SELECT
     p_date
    ,SUM(p_summa) AS "ПЛЯТЕЖ"
    ,LISTAGG(type_oper || ':' || TO_CHAR(p_summa,'999990.99'), '; ') WITHIN GROUP (ORDER BY type_oper) AS "РАСШИФРОВКА"
    ,TO_CHAR(
    --ABS(
    (
        SELECT
            SUM(p_summa)
            FROM c##course.plan_oper issued
            WHERE
                issued.collection_id = po.collection_id
                AND
                issued.type_oper='Выдача кредита'
    ) 
    -
    (
        SELECT 
            SUM(p_summa)
            FROM c##course.plan_oper repayment
            WHERE 
                repayment.collection_id = po.collection_id
                AND
                repayment.type_oper = 'Погашение кредита'
                AND
                repayment.p_date <= po.p_date
    --)
    ),'99990.99') AS "ОСТАТОК ЗАДОЛЖЕННОСТИ"

    FROM c##course.plan_oper po

    WHERE 
        collection_id = (SELECT MAX(collect_plan) FROM pr_credit)
        AND
        type_oper IN  ('Погашение процентов','Погашение кредита')

    GROUP BY
         collection_id
        ,p_date
