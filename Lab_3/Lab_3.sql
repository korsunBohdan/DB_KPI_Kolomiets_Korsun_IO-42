-- Спочатку видаляємо згадки про товар із деталей замовлень
DELETE FROM order_items
WHERE product_id IN (SELECT product_id FROM products WHERE category_id = 3);

-- Видаляємо згадки про товар із деталей поставок
DELETE FROM supply_items
WHERE product_id IN (SELECT product_id FROM products WHERE category_id = 3);

--  Видаляємо цей товар із залишків на складах
DELETE FROM stock_balances
WHERE product_id IN (SELECT product_id FROM products WHERE category_id = 3);

-- Тепер база дозволить безпечно видалити сам товар
DELETE FROM products
WHERE category_id = 3;

-- Видаляємо непотрібну категорію
DELETE FROM categories
WHERE category_name = 'Вибухоневідоме';

-- Додавання нової категорії товарів
INSERT INTO categories (category_name)
VALUES ('Електроніка');

-- Додавання нового складу
INSERT INTO warehouse (warehouse_name, address)
VALUES ('Омега', 'Одеса, вул. Морська, 1');

-- Додавання нового товару до нової категорії
INSERT INTO products (category_id, product_name, product_description, product_price)
VALUES (4, 'Павербанк', 'Для живлення роутера під час відключень', 1500.00);

-- Оновлення ціни товару у зв'язку з високими цінами на бензин
UPDATE products
SET product_price = 120.00
WHERE product_id = 1;

-- Зміна контактної пошти клієнта
UPDATE clients
SET client_email = 'new_nadi@lll.ua'
WHERE client_id = 3;

-- Оновлення назви складу
UPDATE warehouse
SET warehouse_name = 'Головний Гараж'
WHERE warehouse_name = 'Гараж';

-- Видалення дрібних замовлень та їхніх деталей
DELETE FROM order_items
WHERE order_id IN (SELECT order_id FROM orders WHERE total_price < 50.00);

DELETE FROM orders
WHERE total_price < 50.00;

-- Отримання списку всіх категорій
SELECT * FROM categories;

-- Отримання всіх товарів конкретної категорії (наприклад, Вибухонебезпечне)
SELECT * FROM products
WHERE category_id = 4;

-- Перегляд усіх складів
SELECT * FROM warehouse;

-- Перегляд усіх клієнтів
SELECT * FROM clients;
