------
------ Удаление таблицы CLIENTS
------

DROP TABLE c##course.client;

------
------ Создание таблицы клиенты (физ. лица)
------

CREATE TABLE c##course.client (
    id          NUMBER,
    cl_name     VARCHAR2(100),
    date_birth  DATE
);

------
------ Создание индекса
------

CREATE UNIQUE INDEX c##course.idx_client_id
    ON c##course.client (id);

------
------ Добавление первичного ключа
------

ALTER TABLE c##course.client
    ADD
    ( 
        CONSTRAINT client_id_pk
       		 PRIMARY KEY (id)
    );


