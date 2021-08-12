EXPLAIN PLAN FOR
SELECT
              dog.num_dog
            , cli.cl_name
            , dog.summa_dog
            , dog.date_begin
            , dog.date_end
            -- Остаток ссудной задолженности 
            , sum_fact.sum_vidano - NVL(sum_fact.sum_pogasheno,0)
            -- Сумма предстоящих процентов к погашению 
            , NVL(sum_pogasheno_percent_plan.sum_pogasheno_percent_plan,0) - NVL(sum_fact.sum_pogasheno_percent,0)


    FROM
        c##course.pr_credit dog

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
                f_date <= TO_DATE('10.10.2020','DD.MM.YYYY')
                
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
                p_date <= TO_DATE('10.10.2020','DD.MM.YYYY')
                AND
                type_oper = 'Погашение процентов'
            GROUP BY collection_id
   ) sum_pogasheno_percent_plan
   ON (dog.collect_plan = sum_pogasheno_percent_plan.collection_id)

   WHERE
        dog.date_begin <= TO_DATE('10.10.2020','DD.MM.YYYY')
   ORDER BY
        dog.date_begin
;

--select * from table(DBMS_XPLAN.DISPLAY(format => 'ALL'));

/*

0,124 seconds

Plan hash value: 3477279710
 
-------------------------------------------------------------------------------------
| Id  | Operation               | Name      | Rows  | Bytes | Cost (%CPU)| Time     |
-------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT        |           |    14 |  2576 |    17  (18)| 00:00:01 |
|   1 |  SORT ORDER BY          |           |    14 |  2576 |    17  (18)| 00:00:01 |
|*  2 |   HASH JOIN             |           |    14 |  2576 |    16  (13)| 00:00:01 |
|*  3 |    HASH JOIN OUTER      |           |    14 |  1736 |    13  (16)| 00:00:01 |
|*  4 |     HASH JOIN OUTER     |           |    14 |  1064 |     9  (12)| 00:00:01 |
|*  5 |      TABLE ACCESS FULL  | PR_CREDIT |    14 |   756 |     3   (0)| 00:00:01 |
|   6 |      VIEW               |           |    18 |   396 |     6  (17)| 00:00:01 |
|   7 |       HASH GROUP BY     |           |    18 |  1044 |     6  (17)| 00:00:01 |
|*  8 |        TABLE ACCESS FULL| PLAN_OPER |    31 |  1798 |     5   (0)| 00:00:01 |
|   9 |     VIEW                |           |    22 |  1056 |     4  (25)| 00:00:01 |
|  10 |      HASH GROUP BY      |           |    22 |  1254 |     4  (25)| 00:00:01 |
|* 11 |       TABLE ACCESS FULL | FACT_OPER |    66 |  3762 |     3   (0)| 00:00:01 |
|  12 |    TABLE ACCESS FULL    | CLIENT    |    24 |  1440 |     3   (0)| 00:00:01 |
-------------------------------------------------------------------------------------
 
Query Block Name / Object Alias (identified by operation id):
-------------------------------------------------------------
 
   1 - SEL$27D59993
   5 - SEL$27D59993 / DOG@SEL$1
   6 - SEL$5        / SUM_POGASHENO_PERCENT_PLAN@SEL$4
   7 - SEL$5       
   8 - SEL$5        / PLAN_OPER@SEL$5
   9 - SEL$3        / SUM_FACT@SEL$2
  10 - SEL$3       
  11 - SEL$3        / FACT_OPER@SEL$3
  12 - SEL$27D59993 / CLI@SEL$1
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("DOG"."ID_CLIENT"="CLI"."ID")
   3 - access("DOG"."COLLECT_FACT"="SUM_FACT"."COLLECTION_ID"(+))
   4 - access("DOG"."COLLECT_PLAN"="SUM_POGASHENO_PERCENT_PLAN"."COLLECTION_I
              D"(+))
   5 - filter("DOG"."DATE_BEGIN"<=TO_DATE(' 2020-10-10 00:00:00', 
              'syyyy-mm-dd hh24:mi:ss'))
   8 - filter("P_DATE"<=TO_DATE(' 2020-10-10 00:00:00', 'syyyy-mm-dd 
              hh24:mi:ss') AND "TYPE_OPER"='Погашение процентов')
  11 - filter("F_DATE"<=TO_DATE(' 2020-10-10 00:00:00', 'syyyy-mm-dd 
              hh24:mi:ss'))
 
Column Projection Information (identified by operation id):
-----------------------------------------------------------
 
   1 - (#keys=1) "DOG"."DATE_BEGIN"[DATE,7], "DOG"."NUM_DOG"[VARCHAR2,10], 
       "CLI"."CL_NAME"[VARCHAR2,100], "DOG"."SUMMA_DOG"[NUMBER,22], 
       "DOG"."DATE_END"[DATE,7], "SUM_FACT"."SUM_VIDANO"-NVL("SUM_FACT"."SUM_POGASHE
       NO",0)[22], NVL("SUM_POGASHENO_PERCENT_PLAN"."SUM_POGASHENO_PERCENT_PLAN",0)-
       NVL("SUM_FACT"."SUM_POGASHENO_PERCENT",0)[22]
   2 - (#keys=1) "DOG"."NUM_DOG"[VARCHAR2,10], "DOG"."SUMMA_DOG"[NUMBER,22], 
       "DOG"."DATE_BEGIN"[DATE,7], "DOG"."DATE_END"[DATE,7], 
       "CLI"."CL_NAME"[VARCHAR2,100], "SUM_POGASHENO_PERCENT_PLAN"."SUM_POGASHENO_PE
       RCENT_PLAN"[NUMBER,22], "SUM_FACT"."SUM_POGASHENO_PERCENT"[NUMBER,22], 
       "SUM_FACT"."SUM_VIDANO"[NUMBER,22], "SUM_FACT"."SUM_POGASHENO"[NUMBER,22], 
       "CLI"."CL_NAME"[VARCHAR2,100]
   3 - (#keys=1) "DOG"."NUM_DOG"[VARCHAR2,10], "DOG"."SUMMA_DOG"[NUMBER,22], 
       "DOG"."DATE_BEGIN"[DATE,7], "DOG"."DATE_END"[DATE,7], 
       "DOG"."ID_CLIENT"[NUMBER,22], "SUM_POGASHENO_PERCENT_PLAN"."SUM_POGASHENO_PER
       CENT_PLAN"[NUMBER,22], "SUM_FACT"."SUM_POGASHENO_PERCENT"[NUMBER,22], 
       "SUM_FACT"."SUM_VIDANO"[NUMBER,22], "SUM_FACT"."SUM_POGASHENO"[NUMBER,22]
   4 - (#keys=1; rowset=256) "DOG"."NUM_DOG"[VARCHAR2,10], 
       "DOG"."SUMMA_DOG"[NUMBER,22], "DOG"."DATE_BEGIN"[DATE,7], 
       "DOG"."DATE_END"[DATE,7], "DOG"."ID_CLIENT"[NUMBER,22], 
       "DOG"."COLLECT_FACT"[NUMBER,22], "SUM_POGASHENO_PERCENT_PLAN"."SUM_POGASHENO_
       PERCENT_PLAN"[NUMBER,22]
   5 - (rowset=256) "DOG"."NUM_DOG"[VARCHAR2,10], 
       "DOG"."SUMMA_DOG"[NUMBER,22], "DOG"."DATE_BEGIN"[DATE,7], 
       "DOG"."DATE_END"[DATE,7], "DOG"."ID_CLIENT"[NUMBER,22], 
       "DOG"."COLLECT_PLAN"[NUMBER,22], "DOG"."COLLECT_FACT"[NUMBER,22]
   6 - (rowset=256) "SUM_POGASHENO_PERCENT_PLAN"."SUM_POGASHENO_PERCENT_PLAN"
       [NUMBER,22], "SUM_POGASHENO_PERCENT_PLAN"."COLLECTION_ID"[NUMBER,22]
   7 - (#keys=1; rowset=256) "COLLECTION_ID"[NUMBER,22], SUM("P_SUMMA")[22]
   8 - (rowset=256) "COLLECTION_ID"[NUMBER,22], "P_SUMMA"[NUMBER,22]
   9 - "SUM_FACT"."COLLECTION_ID"[NUMBER,22], 
       "SUM_FACT"."SUM_VIDANO"[NUMBER,22], "SUM_FACT"."SUM_POGASHENO"[NUMBER,22], 
       "SUM_FACT"."SUM_POGASHENO_PERCENT"[NUMBER,22]
  10 - (#keys=1) "COLLECTION_ID"[NUMBER,22], SUM(CASE "TYPE_OPER" WHEN 
       'Погашение процентов' THEN "F_SUMMA" ELSE 0 END )[22], SUM(CASE "TYPE_OPER" 
       WHEN 'Погашение кредита' THEN "F_SUMMA" ELSE 0 END )[22], SUM(CASE 
       "TYPE_OPER" WHEN 'Выдача кредита' THEN "F_SUMMA" ELSE 0 END )[22]
  11 - (rowset=256) "COLLECTION_ID"[NUMBER,22], "F_SUMMA"[NUMBER,22], 
       "TYPE_OPER"[VARCHAR2,50]
  12 - "CLI"."ID"[NUMBER,22], "CLI"."CL_NAME"[VARCHAR2,100]

*/