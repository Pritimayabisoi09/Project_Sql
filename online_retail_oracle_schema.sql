
-- ONLINE RETAIL SALES SQL SCHEMA (ORACLE)

-- Drop tables if they exist
DROP TABLE OrderDetails CASCADE CONSTRAINTS;
DROP TABLE Payments CASCADE CONSTRAINTS;
DROP TABLE Orders CASCADE CONSTRAINTS;
DROP TABLE Products CASCADE CONSTRAINTS;
DROP TABLE Customers CASCADE CONSTRAINTS;

-- Drop sequences if they exist
DROP SEQUENCE customer_seq;
DROP SEQUENCE product_seq;
DROP SEQUENCE order_seq;
DROP SEQUENCE order_detail_seq;
DROP SEQUENCE payment_seq;

-- Create Sequences
CREATE SEQUENCE customer_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE product_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE order_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE order_detail_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE payment_seq START WITH 1 INCREMENT BY 1;

-- Customers
CREATE TABLE Customers (
  customer_id NUMBER PRIMARY KEY,
  name VARCHAR2(30),
  email VARCHAR2(30) UNIQUE,
  phone VARCHAR2(30),
  address VARCHAR2(50),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Products
CREATE TABLE Products (
  product_id NUMBER PRIMARY KEY,
  name VARCHAR2(30),
  description CLOB,
  price NUMBER(10,2),
  stock NUMBER,
  category VARCHAR2(30)
);

-- Orders
CREATE TABLE Orders (
  order_id NUMBER PRIMARY KEY,
  customer_id NUMBER REFERENCES Customers(customer_id),
  order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  status VARCHAR2(30),
  total NUMBER(10,2)
);

-- OrderDetails
CREATE TABLE OrderDetails (
  order_detail_id NUMBER PRIMARY KEY,
  order_id NUMBER REFERENCES Orders(order_id),
  product_id NUMBER REFERENCES Products(product_id),
  quantity NUMBER,
  price NUMBER(10,2)
);

-- Payments
CREATE TABLE Payments (
  payment_id NUMBER PRIMARY KEY,
  order_id NUMBER REFERENCES Orders(order_id),
  payment_date TIMESTAMP,
  amount NUMBER(10,2),
  method VARCHAR2(30),
  status VARCHAR2(30)
);

-- Data Insertion

-- Customers
insert into Customers (customer_id, name, email, phone, address) 
values (customer_seq.NEXTVAL, 'Alice', 'alice@example.com', '9876543210', 'Delhi');

insert into Customers (customer_id, name, email, phone, address) 
values (customer_seq.NEXTVAL, 'Bob', 'bob@example.com', '9123456780', 'Mumbai');

-- Products
insert into Products (product_id, name, description, price, stock, category) 
values (product_seq.NEXTVAL, 'Laptop', 'Gaming Laptop', 75000.00, 10, 'Electronics');

insert into Products (product_id, name, description, price, stock, category)
values (product_seq.NEXTVAL, 'Shoes', 'Running Shoes', 2000.00, 50, 'Fashion');

-- Orders
nsert into Orders (order_id, customer_id, order_date, status, total) 
values (order_seq.NEXTVAL, 1, CURRENT_TIMESTAMP, 'Completed', 77000.00);

-- OrderDetails
insert into OrderDetails (order_detail_id, order_id, product_id, quantity, price)
values (order_detail_seq.NEXTVAL, 1, 1, 1, 75000.00);

insert into OrderDetails (order_detail_id, order_id, product_id, quantity, price)
values (order_detail_seq.NEXTVAL, 1, 2, 1, 2000.00);

-- Payments
insert into Payments (payment_id, order_id, payment_date, amount, method, status)
values (payment_seq.NEXTVAL, 1, CURRENT_TIMESTAMP, 77000.00, 'Credit Card', 'Paid');


-- Sales Report Queries

-- Customer Order Summary
SELECT c.name, o.order_id, o.order_date, o.total, p.method
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Payments p ON o.order_id = p.order_id;

-- Product Sales Report
SELECT pr.name AS product, SUM(od.quantity) AS total_sold, SUM(od.price * od.quantity) AS total_revenue
FROM OrderDetails od
JOIN Products pr ON od.product_id = pr.product_id
GROUP BY pr.name;

-- Sales Summary View
CREATE OR REPLACE VIEW SalesSummary AS
SELECT o.order_id, c.name AS customer, o.total, p.method, p.status
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN Payments p ON o.order_id = p.order_id;
