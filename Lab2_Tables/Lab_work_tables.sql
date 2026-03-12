/* Видалення таблиць для можливості їх повторного створення, 
активного оновлення і відсутності конфліктів при повторному запуску цієї 
SQL DDL-інструкції зі створення кожної таблиці з ERD.
*/
DROP TABLE IF EXISTS stock_balances;
DROP TABLE IF EXISTS supply_items;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS supply_deliver;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS warehouse;
DROP TABLE IF EXISTS supplier;
DROP TABLE IF EXISTS employee;
DROP TABLE IF EXISTS clients;

-- Довідники, незалежні таблиці
CREATE TABLE clients (
    client_id SERIAL PRIMARY KEY,
    client_name_surname VARCHAR(60) NOT NULL,
    client_phone CHAR(12) NOT NULL UNIQUE,
    client_email CHAR(64) NOT NULL UNIQUE
);

CREATE TABLE employee (
    employee_id SERIAL PRIMARY KEY,
    employee_full_name VARCHAR(80) NOT NULL,
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
    address VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(40) NOT NULL UNIQUE
);

-- Основні сутності, навколо яких будується логіка роботи системи 
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    category_id INT NOT NULL REFERENCES categories(category_id),
    product_name VARCHAR(60) NOT NULL,
    product_description TEXT,
    product_price DECIMAL(10, 2) NOT NULL DEFAULT 0.00 CHECK(product_price >= 0)
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    client_id INT NOT NULL REFERENCES clients(client_id), 
    employee_id INT NOT NULL REFERENCES employee(employee_id),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    total_price DECIMAL(10, 3) NOT NULL DEFAULT 0.00 CHECK(total_price >= 0)
);

CREATE TABLE supply_deliver (
    supply_delivery_id SERIAL PRIMARY KEY,
    supplier_id INT NOT NULL REFERENCES supplier(supplier_id),
    employee_id INT NOT NULL REFERENCES employee(employee_id),
    warehouse_id INT NOT NULL REFERENCES warehouse(warehouse_id),
    delivery_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

/* Таблиці зв'язків та залишків, проміжні таблиці з реалізацією 
зв'язків багато до багатьох */
CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL REFERENCES orders(order_id),
    product_id INT NOT NULL REFERENCES products(product_id),
    quantity INT NOT NULL DEFAULT(0) CHECK(quantity >= 0),
    sale_price DECIMAL(10, 2) NOT NULL CHECK(sale_price >= 0)
);

CREATE TABLE supply_items (
    supply_item_id SERIAL PRIMARY KEY,
    supply_delivery_id INT NOT NULL REFERENCES supply_deliver(supply_delivery_id),
    product_id INT NOT NULL REFERENCES products(product_id),
    purchase_price DECIMAL(10, 2) NOT NULL CHECK(purchase_price >= 0),
    quantity INT NOT NULL DEFAULT(0) CHECK(quantity >= 0)
);

CREATE TABLE stock_balances (
    stock_id SERIAL PRIMARY KEY,
    warehouse_id INT NOT NULL REFERENCES warehouse(warehouse_id),
    product_id INT NOT NULL REFERENCES products(product_id),
    last_update DATE NOT NULL DEFAULT CURRENT_DATE,
    quantity INT NOT NULL DEFAULT(0) CHECK(quantity >= 0)
);

-- Заповнення таблиць завдяки INSERT
INSERT INTO categories (category_name) VALUES ('Вибухонебезпечне'), ('Вибухобезпечне'), ('Вибухоневідоме');

INSERT INTO clients (client_name_surname, client_phone, client_email) VALUES 
('Стів Майнкрафт', '380883335353', 'iam_stiv@lll.com'),
('Ісаак Шекельович', '972222222222', 'taki_da@lll.com'),
('Надія Остання', '380883335375', 'nadi_nema@lll.ua');

INSERT INTO employee (employee_full_name, employee_position, employee_phone, employee_email) VALUES 
('Саня Срібнорукий', 'Оформлювач', '380998877665', 'silver_sanic.s@company.ua'),
('Вова Віст', 'Грузчик', '380998877660', 'vova.v@company.ua'),
('Володік Потужнік', 'Старший менеджер', '380671112233', 'petro.p@company.ua'),
('Адік Азізбек', 'Головний директор', '380934445566', 'adik.a@company.ua');

INSERT INTO supplier (company_name, contact_person, contact_phone) VALUES 
('ТОВ Лісозрізальня Поляна', 'Василь Колода', '380509998877'),
('ФОП Рошель', 'Петро Скарб', '380501198877'),
('ТОВ Нафтова демократія', 'Джон Сміт', '001509998811');

INSERT INTO warehouse (warehouse_name, address) VALUES 
('Гараж', 'Київ, вул. Гаражна, 10'),
('Ангар', 'Червоносілка, вул. складальна, 5'),
('Браво', 'Великі печівці, вул. пекельна, 66'),
('Дельта', 'Бориспіль, вул. авіаційна, 99');

INSERT INTO products (category_id, product_name, product_description, product_price) VALUES 
(1, 'Дизельне паливо', 'Дизельне паливо для вашого тостеру', 100.00),
(2, 'Колода', 'Колода для обігріву холодильника', 200.50),
(3, 'Золотий відкивач', 'Бюджетний рулет, ідеальний для розрізання лінійкою під час шкільного свята', 49.99);

INSERT INTO orders (client_id, employee_id, total_price) VALUES 
(1, 1, 1500.00),
(2, 1, 300.50),
(3, 1, 49.99);

INSERT INTO supply_deliver (supplier_id, employee_id, warehouse_id) VALUES 
(1, 2, 1),
(2, 2, 2);

-- 2. Деталізуємо поставки: що саме привезли, за якою ціною і скільки
INSERT INTO supply_items (supply_delivery_id, product_id, purchase_price, quantity) VALUES 
(1, 1, 80.00, 50),
(2, 2, 150.00, 100),
(2, 3, 30.00, 10);

-- 3. Розписуємо деталі замовлень клієнтів (щоб суми зійшлися з таблицею orders)
INSERT INTO order_items (order_id, product_id, quantity, sale_price) VALUES 
(1, 1, 15, 100.00),
(2, 2, 1, 200.50),
(2, 1, 1, 100.00),
(3, 3, 1, 49.99); 

INSERT INTO stock_balances (warehouse_id, product_id, quantity) VALUES 
(1, 1, 34),
(2, 2, 99),
(2, 3, 9);

-- Відображення таблиць у вкладці Data Output
-- 1. Довідники
SELECT * FROM categories;
SELECT * FROM clients;
SELECT * FROM employee;
SELECT * FROM supplier;
SELECT * FROM warehouse;

-- 2. Основні сутності та документи
SELECT * FROM products;
SELECT * FROM orders;
SELECT * FROM supply_deliver;

-- 3. Деталізація документів та залишки
SELECT * FROM order_items;
SELECT * FROM supply_items;
SELECT * FROM stock_balances;