--alter session set container=testdbplug;
--ALTER SESSION SET CURRENT_SCHEMA=HR;

SELECT
        a.FIRST_NAME,
        a.LAST_NAME,
        a.JOB_ID,
        b.max_salary
    FROM  employees a
    LEFT JOIN
        (
            SELECT
                job_id, 
                MAX(salary) as max_salary 
            FROM EMPLOYEES
            GROUP BY job_id
    ) b
    ON a.job_id = b.job_id;
    
SELECT
        FIRST_NAME,
        LAST_NAME,
        JOB_ID,
        MAX(salary) OVER (PARTITION BY job_id ORDER BY salary) AS max_salary
    FROM  employees;
    
SELECT
        FIRST_NAME,
        LAST_NAME,
        JOB_ID
    FROM  employees
    WHERE rownum < 11
    ORDER BY LAST_NAME;
    
    

