USE northwind;

Select * FROM customers;
Select * from orders;
Select * from order_details;

SELECT * FROM customers WHERE Country = 'Germany';

SELECT OrderID, ProductID, Quantity
FROM order_details
WHERE Quantity > 20
ORDER BY Quantity DESC;

SELECT OrderID, SUM(UnitPrice * Quantity * (1 - Discount)) AS total_sales
FROM order_details
GROUP BY OrderID
ORDER BY total_sales DESC;

SELECT c.CustomerID, c.CompanyName, o.OrderID, o.OrderDate
FROM customers c
INNER JOIN orders o ON c.CustomerID = o.CustomerID;

SELECT c.CustomerID, c.CompanyName, o.OrderID
FROM customers c
LEFT JOIN orders o ON c.CustomerID = o.CustomerID;

SELECT c.CustomerID, c.CompanyName, o.OrderID
FROM customers c
RIGHT JOIN orders o ON c.CustomerID = o.CustomerID;

SELECT DISTINCT c.CustomerID, c.CompanyName
FROM customers c
JOIN orders o ON c.CustomerID = o.CustomerID
JOIN order_details od ON o.OrderID = od.OrderID
GROUP BY c.CustomerID, c.CompanyName
HAVING SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) > (
    SELECT AVG(order_total) 
    FROM (
        SELECT SUM(UnitPrice * Quantity * (1 - Discount)) AS order_total
        FROM order_details
        GROUP BY OrderID
    ) AS avg_table
);

SELECT c.CustomerID, c.CompanyName, 
       AVG(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS avg_order_value
FROM customers c
JOIN orders o ON c.CustomerID = o.CustomerID
JOIN order_details od ON o.OrderID = od.OrderID
GROUP BY c.CustomerID, c.CompanyName
ORDER BY avg_order_value DESC;

SELECT c.Country, SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS total_revenue
FROM customers c
JOIN orders o ON c.CustomerID = o.CustomerID
JOIN order_details od ON o.OrderID = od.OrderID
GROUP BY c.Country
ORDER BY total_revenue DESC;

CREATE VIEW HighValueOrders AS
SELECT o.OrderID, c.CompanyName, 
       SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS order_total
FROM customers c
JOIN orders o ON c.CustomerID = o.CustomerID
JOIN order_details od ON o.OrderID = od.OrderID
GROUP BY o.OrderID, c.CompanyName
HAVING order_total > 500;

SELECT * FROM HighValueOrders;

CREATE INDEX idx_country ON customers(Country(50));

DROP INDEX idx_orderid ON order_details;
CREATE INDEX idx_orderid ON order_details(OrderID);

EXPLAIN SELECT * FROM customers WHERE Country = 'Germany';