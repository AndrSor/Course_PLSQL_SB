
--DBS_OUTPUT.PUT('Test');

REM DROP VIEW view_get_oper_dates;
REM CREATE OR REPLACE VIEW view_get_oper_dates
REM AS

SELECT
      MIN(dt) AS from_dt
    , MAX(dt) AS to_dt
    FROM
        (
            SELECT
                f_date dt
                FROM c##course.fact_oper
            UNION
            SELECT
                p_date dt
                FROM c##course.plan_oper
        ) all_dt
;