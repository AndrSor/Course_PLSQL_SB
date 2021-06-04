
------
------ Удаление таблицы ORGANISATIONS
------

DROP TABLE c##course.organisations;

------
------ Создание таблицы Контрагенты
------

CREATE TABLE c##course.organisations (
      id       NUMBER
    , name     VARCHAR2(250)
    
);

------
------ Создание индекса
------

CREATE UNIQUE INDEX c##course.idx_organisations_id
    ON c##course.organisations (id);

------
------ Добавление первичного ключа
------

ALTER TABLE c##course.organisations
    ADD
    ( 
        CONSTRAINT organisations_id_pk
       		 PRIMARY KEY (id)
    );


