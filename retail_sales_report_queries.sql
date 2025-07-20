
-- REPORT QUERIES FOR ONLINE RETAIL SALES DATABASE (ORACLE)

-- 1. Customer Order Summary
SELECT c.name, o.order_id, o.order_date, o.total, p.method
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Payments p ON o.order_id = p.order_id;

-- 2. Product Sales Report
SELECT pr.name AS product, SUM(od.quantity) AS total_sold, SUM(od.price * od.quantity) AS total_revenue
FROM OrderDetails od
JOIN Products pr ON od.product_id = pr.product_id
GROUP BY pr.name;

-- 3. Sales Summary View
CREATE OR REPLACE VIEW SalesSummary AS
SELECT o.order_id, c.name AS customer, o.total, p.method, p.status
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN Payments p ON o.order_id = p.order_id;
