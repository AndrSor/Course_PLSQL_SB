CREATE OR REPLACE PROCEDURE c##course.pr_create_credit (
      client_name     IN varchar2        -- Клиент ФИО
    , client_birth    IN date            -- Дата рождения Клиента
    , summa_dog       IN number          -- Сумма кредита
    , persent_dog     IN number          -- Годовая процентная ставка
    , duration_dog    IN number          -- Срок кредитования месяцев
    , dogovor         OUT varchar2       -- Договор  
)
AS
    client_id                   number;
    credit_id                   number;
    collect_plan_id             number;
    collect_fact_id             number;
    date_begin                  date;
    date_end                    date;
    year_dog                    varchar2(4);
    num_dog                     number := 1;
    amount_dog_in_current_year  number := 0;
    credit_month_percent        number;     -- ежемесячная процентная ставка
    annuit_pay                  number;     -- размер аннуитентного платежа
    p_date                      date;       -- планируемая дата аннуитентного платежа
    p_summa_percent             number;     -- ежемесячное погашение процентов
    p_summa_body                number;     -- ежемесячное погашение кредита
    summa_dog_ostat             number;     -- остаток по кредиту

BEGIN

    c##course.pr_create_client(client_name,client_birth,client_id);
    
    date_begin := CURRENT_DATE;
    date_end   := ADD_MONTHS(date_begin,duration_dog);
    year_dog   := TO_CHAR(date_begin,'YYYY');
    
    -- Количество договоров в этом году
    SELECT
        COUNT(*) INTO amount_dog_in_current_year
        FROM c##course.pr_credit
        WHERE
            num_dog LIKE  year_dog || '/%';

    -- Если еще договоров в этом году нет то номер договора [текущий год]+'/1'
    -- Иначе находим полледний номер договора + 1 
    IF amount_dog_in_current_year > 0 THEN
    
        SELECT
            MAX(TO_NUMBER(REPLACE(num_dog, year_dog || '/',''))) + 1 INTO num_dog
            FROM c##course.pr_credit
            WHERE
                num_dog LIKE  year_dog || '/%';
   
    END IF;
   
    SAVEPOINT add_dog;
    
    dogovor := year_dog || '/' || num_dog;

    credit_id       := c##course.seq.nextval;
    collect_plan_id := c##course.seq.nextval;
    collect_fact_id := c##course.seq.nextval;
    
    INSERT INTO c##course.pr_credit
    (
          id
        , num_dog
        , summa_dog
        , date_begin
        , date_end
        , id_client
        , collect_plan
        , collect_fact
    ) VALUES(
          credit_id
        , year_dog || '/' || num_dog
        , summa_dog
        , date_begin
        , date_end
        , client_id
        , collect_plan_id
        , collect_fact_id
    );
    
    credit_month_percent := persent_dog / 100 / 12;
    
    annuit_pay := ROUND(summa_dog * (credit_month_percent + credit_month_percent / (POWER((1 + credit_month_percent),duration_dog)-1)),2);
    
    summa_dog_ostat := summa_dog;
    
    INSERT INTO plan_oper
    (
         collection_id
        ,p_date
        ,p_summa
        ,type_oper
    ) VALUES (
         collect_plan_id
        ,date_begin
        ,summa_dog
        ,'Выдача кредита'
    );
    
    FOR i IN 1..duration_dog LOOP
        
        p_date := ADD_MONTHS(date_begin,i);
        p_summa_percent := ROUND(summa_dog_ostat * credit_month_percent);
        p_summa_body := annuit_pay - p_summa_percent;
        summa_dog_ostat := summa_dog_ostat - p_summa_body;

        INSERT INTO c##course.plan_oper
        (
             collection_id
            ,p_date
            ,p_summa
            ,type_oper
        ) VALUES (
             collect_plan_id
            ,p_date
            ,p_summa_percent
            ,'Погашение процентов'
        );
        INSERT INTO c##course.plan_oper
        (
             collection_id
            ,p_date
            ,p_summa
            ,type_oper
        ) VALUES (
             collect_plan_id
            ,p_date
            ,p_summa_body
            ,'Погашение кредита'
        );

        
    END LOOP;
    
    COMMIT;
    

EXCEPTION

    WHEN OTHERS
    THEN
        ROLLBACK TO add_dog;

END;

/