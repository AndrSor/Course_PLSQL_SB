
SELECT
     credit.id
    ,credit.num_dog
    ,credit.summa_dog
    ,credit.date_begin
    ,credit.date_end
    ,client.cl_name
    FROM c##course.pr_credit credit
    LEFT JOIN c##course.client client
    ON credit.id_client = client.id;