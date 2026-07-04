select count(CustomerID) as totalcustomers
from [dbo].[Customers] 
---------------------------------------------------------------------------------
select count(OrderID) as totalorders
from [dbo].[Orders] 
-------------------------------------------------------------------------------
select sum(TotalAmount) as totalrevenue
from [dbo].[Orders]
---------------------------------------------------------------------------------
select avg(TotalAmount) as AvgOrderValue
from [dbo].[Orders]
------------------------------------------------------------------------------
select count(ProductID) as totalproducts
from [dbo].[Products]
---------------------------------------------------------------------------------
select sum(Quantity * UnitPrice) as totalproductsold
from [dbo].[OrderDetails]

-------------------------------------------
SELECT MAX(UnitPrice) AS MostExpensiveProduct 
FROM OrderDetails; 
------------------------------------------------------------------------------------
 
SELECT MIN(UnitPrice) AS LeastExpensiveProduct 
FROM OrderDetails
-------------------------------------------------------------------------------
select CustomerID ,count(OrderID) as totalorderpercustomers
from [dbo].[Orders]
group by CustomerID 
order by totalorderpercustomers desc;
------------------------------------------------------------------------
select sum(Quantity) as Totalstockqnantity
from [dbo].[OrderDetails]
-----------------------------------------------------------------------
select count(Quantity) as Totalproductoutofstock
from [dbo].[OrderDetails]
---------------------------------------------------------------------------
select count(*) as totalorders
from [dbo].[Orders]
 where cast(OrderDate as date) = '2024-04-12';     
-------------------------------------------------------------------------
select top 1 OrderID ,OrderDate
from [dbo].[Orders]
order by OrderDate desc
--------------------------------------------------------------
SELECT  
YEAR(OrderDate) AS OrderYear, 
MONTH(OrderDate) AS OrderMonth, 
COUNT(OrderID) AS TotalOrders 
FROM Orders 
GROUP BY YEAR(OrderDate), MONTH(OrderDate) 
ORDER BY OrderYear DESC, OrderMonth DESC; 
-----------------------------------------------------------------------------
select * from [dbo].[Products]
where Price<50  
---------------------------------------------------------------------------
select top 1 [ProductName]
from [dbo].[Products]

order BY [StockQuantity] desc

----------------------------------------------------------------------------
select count(*) as Totalproductsoutofstock
from [dbo].[Products]
--------------------------------------------------------------------------------------------

select Datename(weekday ,OrderDate) as dayofweek ,
count(*) as totalorders
from [dbo].[Orders]
group by Datename(weekday ,OrderDate)
order by totalorders desc;
-------------------------------------------------------------
select CustomerID , avg(TotalAmount) as Averageordervalue
from [dbo].[Orders]
group by  CustomerID 
-------------------------------------------------------------
select * from [dbo].[Products]
 where price> (select avg(TotalAmount)
 from [dbo].[Orders])