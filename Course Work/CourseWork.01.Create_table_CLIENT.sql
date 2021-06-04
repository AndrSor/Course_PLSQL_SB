ALTER SESSION SET CURRENT_SCHEMA=c##course;

------
------ Удаление таблицы CLIENTS
------

DROP TABLE client;

------
------ Создание таблицы клиенты (физ. лица)
------

CREATE TABLE client (
    id          NUMBER,
    cl_name     VARCHAR2(100),
    date_birth  DATE
);

------
------ Создание индекса
------

CREATE UNIQUE INDEX idx_client_id
    ON client (id);

------
------ Добавление первичного ключа
------

ALTER TABLE client
    ADD
    ( 
        CONSTRAINT client_id_pk
       		 PRIMARY KEY (id)
    );


