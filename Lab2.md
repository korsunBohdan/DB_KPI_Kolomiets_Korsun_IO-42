# Лабораторна робота №2

<div align="right">
<strong>Група:</strong> ІО-42

<strong>Виконали:</strong> Коломієць В. М.,
Корсун Б. В.

<strong>Перевірив:</strong> Русінов В. В.
</div>
# Тема: 
Перетворення ER-діаграми на схему PostgreSQL
# Мета: 

•	Написати SQL DDL-інструкції для створення кожної таблиці з вашої ERD в PostgreSQL.

•	Вказати відповідні типи даних для кожного стовпця, вибрати первинний ключ для кожної таблиці та визначити будь-які необхідні зовнішні ключі, обмеження UNIQUE, NOT NULL, CHECK або DEFAULT.

•	Вставити зразки рядків (принаймні 3–5 рядків на таблицю) за допомогою INSERT INTO.

•	Протестувати все в pgAdmin (або іншому клієнті PostgreSQL), щоб переконатися, що таблиці та дані завантажуються правильно.

## SQL файл
Написані DDL-інструкції що реалізують ER-діаграму до першої лабораторної роботи
* [Посилання на SQL інструкції](https://github.com/korsunBohdan/DB_KPI_Kolomiets_Korsun_IO-42/blob/main/Lab2_Tables/Lab_work_tables.sql)

Автоматично згенерована ER-діаграма
<p align="center">
  <img src="Lab2_Tables/ER-Lab2.png" width="700"><br>
  <i>Рисунок 2 – ER-діаграма бази даних магазину згенерована автоматично в pgadmin4</i>
</p>

## Заповнені таблиці данними

<p align="center">
  <img src="Lab2_Tables/Category.png" width="700"><br>
  <i>Рисунок 3 – Заповненна Category</i>
</p>

<p align="center">
  <img src="Lab2_Tables/Client.png" width="700"><br>
  <i>Рисунок 4 – Заповненна Client</i>
</p>

<p align="center">
  <img src="Lab2_Tables/Employee.png" width="700"><br>
  <i>Рисунок 5 – Заповненна Employee</i>
</p>

<p align="center">
  <img src="Lab2_Tables/Order.png" width="700"><br>
  <i>Рисунок 6 – Заповненна Order</i>
</p>

<p align="center">
  <img src="Lab2_Tables/Order_item.png" width="700"><br>
  <i>Рисунок 7 – Заповненна Order items</i>
</p>

<p align="center">
  <img src="Lab2_Tables/Product.png" width="700"><br>
  <i>Рисунок 8 – Заповненна  Product</i>
</p>

<p align="center">
  <img src="Lab2_Tables/Stock balance.png" width="700"><br>
  <i>Рисунок 9 – Заповненна  Stock balance</i>
</p>

<p align="center">
  <img src="Lab2_Tables/Supplier.png" width="700"><br>
  <i>Рисунок 10 – Заповненна Supplier </i>
</p>

<p align="center">
  <img src="Lab2_Tables/Supply items.png" width="700"><br>
  <i>Рисунок 11 – Заповненна Supply items</i>
</p>

<p align="center">
  <img src="Lab2_Tables/Supply_delivery.png" width="700"><br>
  <i>Рисунок 12 – Заповненна Supply delivery</i>
</p>

<p align="center">
  <img src="Lab2_Tables/Warehouse.png" width="700"><br>
  <i>Рисунок 13 – Заповненна Warehouse</i>
</p>

## Висновок
Було спроєктовано та реалізовано реляційну базу даних для управління складським обліком, постачаннями та продажами.
Розроблена база даних відповідає усім вимогам представленим у завдані до роботи
