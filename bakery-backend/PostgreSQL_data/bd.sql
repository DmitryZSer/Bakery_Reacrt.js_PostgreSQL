-- Основные таблицы
CREATE TABLE Roles (
    role_id SERIAL PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL UNIQUE
);

-- Модифицированная таблица Customers с паролем
CREATE TABLE Customers (
    customer_id SERIAL PRIMARY KEY,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50),
    phone VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    dateRegistration DATE NOT NULL DEFAULT CURRENT_DATE
);

CREATE TABLE User_Roles (
    user_role_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES Customers(customer_id),
    role_id INT REFERENCES Roles(role_id)
);

-- Справочник статусов заказов
CREATE TABLE Order_Statuses (
    status_id SERIAL PRIMARY KEY,
    status_name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT
);

-- Категории изделий
CREATE TABLE Categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE
);

-- Изделия
CREATE TABLE Products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description VARCHAR(500),
    composition VARCHAR(500),
    weight INT,
    calories INT,
    proteins NUMERIC(5,2),
    fats NUMERIC(5,2),
    carbohydrates NUMERIC(5,2),
    category_id INT REFERENCES Categories(category_id),
    unit_price NUMERIC(10,2) NOT NULL CHECK (unit_price > 0),
    stock_quantity INT NOT NULL CHECK (stock_quantity >= 0),
    image_path VARCHAR(255)
);


-- Заказы
CREATE TABLE Orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES Customers(customer_id),
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status_id INT REFERENCES Order_Statuses(status_id) NOT NULL,
    pickup_time TIMESTAMP NOT NULL
);

-- Детали заказов
CREATE TABLE Order_Details (
    order_detail_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES Orders(order_id),
    product_id INT REFERENCES Products(product_id),
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(10,2) NOT NULL, -- Цена на момент заказа
    line_total NUMERIC(10,2) GENERATED ALWAYS AS (quantity * unit_price) STORED
);


-- Привязка пользователей к ролям
INSERT INTO User_Roles (customer_id, role_id)
SELECT customer_id, role_id
FROM Customers, Roles
WHERE email = 'admin@example.com' AND role_name = 'admin';

-- 6. Дополнительные функции

-- 1. Регистрация заказа
-- Создание заказа
-- 2. Получение информации о заказе
-- 3. Обновление статуса заказа
-- 4. Отчет по доходам за период
-- 5. Популярные изделия
-- 6. Поиск клиента
-- 7. Проверка остатков
-- 8. Уведомления о готовности