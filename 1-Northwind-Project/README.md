# SQL Data Analysis Project — Northwind Database

A SQL portfolio project analyzing customers, products, orders, and employees using the **Northwind** sample database with **Microsoft SQL Server (SSMS)**.

## About the Data
- **Database:** Northwind
- **Tables used:** `customers`, `products`, `categories`, `orders`, `order_details`, `employees`

## How to Run This Project
1. Restore the Northwind sample database in SQL Server Management Studio (SSMS).
2. Open `SQL_Project_Questions.sql` in SSMS.
3. Run each query individually to see the results.

## Tools Used
- Microsoft SQL Server Management Studio (SSMS)
- T-SQL (JOINs, GROUP BY, Subqueries, Self Joins)

## Skills Demonstrated
- Filtering with `WHERE` and `LIKE`
- Sorting with `ORDER BY`
- Aggregate functions (`COUNT`, `SUM`, `AVG`)
- Grouping with `GROUP BY`
- Table joins (`INNER JOIN`, `LEFT JOIN`)
- Self joins (employee-to-manager relationships)
- Subqueries (filtering against an aggregate value)

---

## Questions & Results

### 1. All customers located in Germany
```sql
SELECT * 
FROM customers
WHERE country = 'Germany';
```
**Result:** 11 customers returned, including Alfreds Futterkiste (Berlin), Blauer See Delikatessen (Mannheim), and Königlich Essen (Brandenburg), among others.

---

### 2. Products ordered by unit price (highest to lowest)
```sql
SELECT productName, unitPrice
FROM products
ORDER BY unitPrice DESC;
```
**Result:** **Côte de Blaye** is the most expensive product at **263.5**, followed by Thüringer Rostbratwurst (123.79) and Mishi Kobe Niku (97).

---

### 3. Count of products per category
```sql
SELECT COUNT(categoryID)
FROM products
GROUP BY categoryID;
```
**Result:** 8 categories returned with product counts of: 12, 12, 13, 10, 7, 6, 5, and 12.

---

### 4. Companies whose name starts with "A"
```sql
SELECT companyName
FROM customers
WHERE companyName LIKE 'A%';
```
**Result:** 4 companies returned — Alfreds Futterkiste, Ana Trujillo Emparedados y helados, Antonio Moreno Taquería, and Around the Horn.

---

### 5. Orders shipped later than their required date
```sql
SELECT * 
FROM orders
WHERE shippedDate > requiredDate;
```
**Result:** 37 late-shipped orders returned, ranging from order 10433 (Feb 2014) to order 10970 (Mar 2015).

---

### 6. Orders with the customer's company name
```sql
SELECT customers.companyName, orders.orderID
FROM orders
INNER JOIN customers
    ON customers.customerID = orders.customerID;
```
**Result:** 830 rows returned — one row per order, matched to its customer's company name.

---

### 7. All employee IDs, including those with no orders (LEFT JOIN)
```sql
SELECT employees.employeeID 
FROM employees
LEFT JOIN orders
    ON employees.employeeID = orders.employeeID;
```
**Result:** 830 rows returned, matching the total number of orders — since every employee in the dataset has handled at least one order, each employeeID repeats once per order they processed.

---

### 8. Total value of each order (unitPrice × quantity)
```sql
SELECT SUM(unitPrice * quantity)
FROM order_details
GROUP BY orderID;
```
**Result:** 830 order totals returned, ranging from as low as ~48 to over 4,000 per order.

---

### 9. Products priced above the average unit price
```sql
SELECT productName
FROM products
WHERE unitprice >
(
    SELECT AVG(unitprice)
    FROM products
);
```
**Result:** 25 products returned, including Uncle Bob's Organic Dried Pears, Côte de Blaye, and Mishi Kobe Niku — all priced above the average across all products.

---

### 10. Employees and their managers (self join)
```sql
SELECT e1.employeeName AS employee, e2.employeeName AS manager
FROM employees e1
JOIN employees e2
    ON e1.reportsTo = e2.employeeID;
```
**Result:**
| Employee | Manager |
|---|---|
| Nancy Davolio | Laura Callahan |
| Janet Leverling | Laura Callahan |
| Margaret Peacock | Laura Callahan |
| Steven Buchanan | Andrew Fuller |
| Michael Suyama | Steven Buchanan |
| Robert King | Steven Buchanan |
| Laura Callahan | Andrew Fuller |
| Anne Dodsworth | Steven Buchanan |

Laura Callahan and Steven Buchanan each manage multiple employees while also reporting to Andrew Fuller, showing a two-tier management structure.

---

## Key Insights
- Germany has 11 customers in the dataset, more than most other countries, reflecting a strong market presence.
- Côte de Blaye is by far the most expensive product (263.5), nearly double the price of the next most expensive item.
- 37 orders (out of 830) were shipped later than required, worth flagging as a fulfillment/logistics issue.
- 25 products (roughly a third of the catalog) are priced above the company's average unit price.
- The management hierarchy has two tiers under Andrew Fuller: Laura Callahan and Steven Buchanan each supervise several employees directly.

## Files in this Repository
- `SQL_Project_Questions.sql` — all 10 questions with their SQL queries
- `README.md` — this file, with results and explanations
