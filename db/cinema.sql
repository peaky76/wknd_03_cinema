DROP TABLE IF EXISTS tickets;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS films;
DROP TABLE IF EXISTS screens;


CREATE TABLE screens (
    id SERIAL PRIMARY KEY,
    number INT,
    capacity INT
);

CREATE TABLE films (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255),
    price VARCHAR(255)
);

CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    funds INT
);

CREATE TABLE tickets (
    id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(id) ON DELETE CASCADE,
    film_id INT REFERENCES films(id) ON DELETE CASCADE
);


