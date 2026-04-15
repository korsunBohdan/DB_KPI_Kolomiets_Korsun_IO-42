
DROP TABLE IF EXISTS stock_balances CASCADE;
DROP TABLE IF EXISTS supply_items CASCADE;
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS supply_deliver CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS warehouse CASCADE;
DROP TABLE IF EXISTS supplier CASCADE;
DROP TABLE IF EXISTS employee CASCADE;
DROP TABLE IF EXISTS clients CASCADE;

CREATE TABLE clients (
    client_id SERIAL PRIMARY KEY,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    client_phone CHAR(12) NOT NULL UNIQUE,
    client_email CHAR(64) NOT NULL UNIQUE
);

CREATE TABLE employee (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    employee_position VARCHAR(64) NOT NULL,
    employee_phone CHAR(12) NOT NULL UNIQUE,
    employee_email CHAR(64) NOT NULL UNIQUE
);

CREATE TABLE supplier (
    supplier_id SERIAL PRIMARY KEY,
    company_name VARCHAR(40) NOT NULL UNIQUE,
    contact_person VARCHAR(80) NOT NULL,
    contact_phone CHAR(12) NOT NULL
);

CREATE TABLE warehouse (
    warehouse_id SERIAL PRIMARY KEY,
    warehouse_name VARCHAR(25) NOT NULL,
    city VARCHAR(30) NOT NULL,
    street_address VARCHAR(50) NOT NULL
);

CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    category_id INT NOT NULL REFERENCES categories(category_id),
    product_name VARCHAR(60) NOT NULL,
    product_description TEXT,
    product_price DECIMAL(10, 2) NOT NULL DEFAULT 0.00 CHECK(product_price >= 0)
);

-- Таблиця замовлень у 3NF (видалено транзитивну залежність total_price)
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    client_id INT NOT NULL REFERENCES clients(client_id), 
    employee_id INT NOT NULL REFERENCES employee(employee_id),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE supply_deliver (
    supply_delivery_id SERIAL PRIMARY KEY,
    supplier_id INT NOT NULL REFERENCES supplier(supplier_id),
    employee_id INT NOT NULL REFERENCES employee(employee_id),
    warehouse_id INT NOT NULL REFERENCES warehouse(warehouse_id),
    delivery_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL REFERENCES orders(order_id),
    product_id INT NOT NULL REFERENCES products(product_id),
    quantity INT NOT NULL DEFAULT(0) CHECK(quantity >= 0),
    sale_price DECIMAL(10, 2) NOT NULL CHECK(sale_price >= 0),
    CONSTRAINT unique_order_product UNIQUE (order_id, product_id)
);

CREATE TABLE supply_items (
    supply_item_id SERIAL PRIMARY KEY,
    supply_delivery_id INT NOT NULL REFERENCES supply_deliver(supply_delivery_id),
    product_id INT NOT NULL REFERENCES products(product_id),
    purchase_price DECIMAL(10, 2) NOT NULL CHECK(purchase_price >= 0),
    quantity INT NOT NULL DEFAULT(0) CHECK(quantity >= 0),
    CONSTRAINT unique_supply_product UNIQUE (supply_delivery_id, product_id)
);

CREATE TABLE stock_balances (
    stock_id SERIAL PRIMARY KEY,
    warehouse_id INT NOT NULL REFERENCES warehouse(warehouse_id),
    product_id INT NOT NULL REFERENCES products(product_id),
    last_update DATE NOT NULL DEFAULT CURRENT_DATE,
    quantity INT NOT NULL DEFAULT(0) CHECK(quantity >= 0),
    CONSTRAINT unique_warehouse_product UNIQUE (warehouse_id, product_id)
);

INSERT INTO categories (category_name) VALUES ('Вибухонебезпечне'), ('Вибухобезпечне'), ('Вибухоневідоме');

INSERT INTO clients (first_name, last_name, client_phone, client_email) VALUES 
('Стів', 'Майнкрафт', '380883335353', 'iam_stiv@lll.com'),
('Ісаак', 'Шекельович', '972222222222', 'taki_da@lll.com'),
('Надія', 'Остання', '380883335375', 'nadi_nema@lll.ua');

INSERT INTO employee (first_name, last_name, employee_position, employee_phone, employee_email) VALUES 
('Саня', 'Срібнорукий', 'Оформлювач', '380998877665', 'silver_sanic.s@company.ua'),
('Вова', 'Віст', 'Грузчик', '380998877660', 'vova.v@company.ua'),
('Володік', 'Потужнік', 'Старший менеджер', '380671112233', 'petro.p@company.ua'),
('Адік', 'Азізбек', 'Головний директор', '380934445566', 'adik.a@company.ua');

INSERT INTO supplier (company_name, contact_person, contact_phone) VALUES 
('ТОВ Лісозрізальня Поляна', 'Василь Колода', '380509998877'),
('ФОП Рошель', 'Петро Скарб', '380501198877'),
('ТОВ Нафтова демократія', 'Джон Сміт', '001509998811');

INSERT INTO warehouse (warehouse_name, city, street_address) VALUES 
('Гараж', 'Київ', 'вул. Гаражна, 10'),
('Ангар', 'Червоносілка', 'вул. Складальна, 5'),
('Браво', 'Великі Печівці', 'вул. Пекельна, 66'),
('Дельта', 'Бориспіль', 'вул. Авіаційна, 99');

INSERT INTO products (category_id, product_name, product_description, product_price) VALUES 
(1, 'Дизельне паливо', 'Дизельне паливо для вашого тостеру', 100.00),
(2, 'Колода', 'Колода для обігріву холодильника', 200.50),
(3, 'Золотий відкивач', 'Бюджетний рулет, ідеальний для розрізання лінійкою', 49.99);

-- Замовлення без поля total_price
INSERT INTO orders (client_id, employee_id) VALUES 
(1, 1),
(2, 1),
(3, 1);

INSERT INTO supply_deliver (supplier_id, employee_id, warehouse_id) VALUES 
(1, 2, 1),
(2, 2, 2);

INSERT INTO supply_items (supply_delivery_id, product_id, purchase_price, quantity) VALUES 
(1, 1, 80.00, 50),
(2, 2, 150.00, 100),
(2, 3, 30.00, 10);

-- Увага: об'єднано дублікат товару #1 в замовленні #2 (15 шт + 1 шт = 16 шт), 
-- щоб не порушувати нове обмеження UNIQUE(order_id, product_id)
INSERT INTO order_items (order_id, product_id, quantity, sale_price) VALUES 
(1, 1, 15, 100.00),
(2, 2, 1, 200.50),
(2, 1, 2, 100.00), 
(3, 3, 1, 49.99); 

INSERT INTO stock_balances (warehouse_id, product_id, quantity) VALUES 
(1, 1, 34),
(2, 2, 99),
(2, 3, 9);