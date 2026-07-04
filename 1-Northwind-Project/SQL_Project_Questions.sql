/* ============================================================
   SQL Data Analysis Project
   Database: Northwind (customers, products, orders, employees,
             order_details, categories)
   ============================================================ */

/* ============================================================
   Question 1 (Easy)
   Show all customers located in Germany.
   ============================================================ */

SELECT * 
FROM customers
WHERE country = 'Germany';

/* ============================================================
   Question 2 (Easy)
   Show all products with their unit price, ordered from the
   most expensive to the cheapest.
   ============================================================ */

SELECT productName, unitPrice
FROM products
ORDER BY unitPrice DESC;

/* ============================================================
   Question 3 (Easy)
   Show the count of products in each category.
   ============================================================ */

SELECT COUNT(categoryID)
FROM products
GROUP BY categoryID;

/* ============================================================
   Question 4 (Easy)
   Show the company names of customers whose company name
   starts with the letter "A".
   ============================================================ */

SELECT companyName
FROM customers
WHERE companyName LIKE 'A%';

/* ============================================================
   Question 5 (Medium)
   Show all orders that were shipped later than their
   required date (late shipments).
   ============================================================ */

SELECT * 
FROM orders
WHERE shippedDate > requiredDate;

/* ============================================================
   Question 6 (Medium)
   Show each order along with the company name of the customer
   who placed it.
   ============================================================ */

SELECT customers.companyName, orders.orderID
FROM orders
INNER JOIN customers
    ON customers.customerID = orders.customerID;

/* ============================================================
   Question 7 (Medium)
   Show all employee IDs, including employees who have never
   handled an order (using LEFT JOIN to keep unmatched employees).
   ============================================================ */

SELECT employees.employeeID 
FROM employees
LEFT JOIN orders
    ON employees.employeeID = orders.employeeID;

/* ============================================================
   Question 8 (Above Average)
   Calculate the total order value (unitPrice * quantity) for
   each order.
   ============================================================ */

SELECT SUM(unitPrice * quantity)
FROM order_details
GROUP BY orderID;

/* ============================================================
   Question 9 (Above Average)
   Show the names of products whose unit price is higher than
   the average unit price across all products.
   ============================================================ */

SELECT productName
FROM products
WHERE unitprice >
(
    SELECT AVG(unitprice)
    FROM products
);

/* ============================================================
   Question 10 (Hard)
   Show each employee along with the name of the manager
   they report to (self join on the employees table).
   ============================================================ */

SELECT e1.employeeName AS employee, e2.employeeName AS manager
FROM employees e1
JOIN employees e2
    ON e1.reportsTo = e2.employeeID;
