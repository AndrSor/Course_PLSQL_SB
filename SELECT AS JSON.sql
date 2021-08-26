SELECT json_arrayagg (  
    json_object (*) returning clob   
) FROM c##course.client
