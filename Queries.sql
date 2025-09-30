---QUERY REQUESTS:

---1️ Sales & Revenue

---Question:“Can you give me total internet sales revenue by month for the last 12 months?”

SELECT TOP 10 YEAR(OrderDate) AS Year, MONTH(OrderDate) AS Month, SUM(SubTotal) AS Total_Sales
FROM Sales.SalesOrderHeader AS s
WHERE OnlineOrderFlag = 1
GROUP BY Year(OrderDate), MONTH(OrderDate)
ORDER BY Year(OrderDate) DESC, MONTH(OrderDate) ASC
---------------------------------------------------

---2️ Top Products

---Question:“Which 10 products generated the highest sales revenue last quarter?”

--> max date is 30/6/2014 --> assume last quarter mean 1/4->30/6 (3 months).

SELECT TOP 10 ProductID, SUM(LineTotal) AS Sales_Revenue
FROM SALES.SalesOrderDetail AS d
LEFT JOIN (SELECT SalesOrderID 
			FROM SALES.SalesOrderHeader
			WHERE OrderDate >= '2014-04-01') AS s
ON s.SalesOrderID = d.SalesOrderID
WHERE s.SalesOrderID IS NOT NULL
GROUP BY ProductID
ORDER BY Sales_Revenue DESC
---------------------------------------------------

---3️ Customer Segmentation

---Question:“List our top 20 individual customers by lifetime sales (internet orders only).”

SELECT a.CustomerID,
		b.FirstName + ' ' + ISNULL(b.MiddleName + '. ','')+ b.LastName AS CustomerName,
		a.Lifetime_sales
FROM (SELECT TOP 20 CustomerID, SUM(SubTotal) AS Lifetime_sales FROM Sales.SalesOrderHeader
		WHERE OnlineOrderFlag = 1
		GROUP BY CustomerID
		ORDER BY Lifetime_sales DESC) AS a

LEFT JOIN Person.Person AS b
ON a.CustomerID  = b.BusinessEntityID
---------------------------------------------------

---4️ Territory Performance

---Question:“Compare sales revenue by sales territory and month for this year.”

--> Assumption: this year mean 2014 (despite having only 6 months)

SELECT b.Name AS Territory_name, a.Month, a.Sales
FROM (SELECT TerritoryID, MONTH(OrderDate) AS Month, SUM(SubTotal) AS Sales
		FROM Sales.SalesOrderHeader
		WHERE Year(OrderDate) = '2014'
		GROUP BY MONTH(OrderDate), TerritoryID
		ORDER BY TerritoryID ASC, MONTH(OrderDate) ASC
		OFFSET 0 ROWS) AS a
LEFT JOIN Sales.SalesTerritory AS b
ON a.TerritoryID = b.TerritoryID

---------------------------------------------------

---5️ Product Category Trends

---Question:“What are the sales trends by product category over the last two years?”

--> Assumption: Last two years include only 2013 and 2014, despite 2014 having only 6 months.

WITH a AS (SELECT ProductID, SUM(LineTotal) AS Total_sales
			FROM SALES.SalesOrderDetail AS d
			LEFT JOIN (SELECT SalesOrderID 
						FROM SALES.SalesOrderHeader
						WHERE OrderDate >= '2013-01-01') AS s
			ON s.SalesOrderID = d.SalesOrderID
			WHERE s.SalesOrderID IS NOT NULL
			GROUP BY ProductID
			ORDER BY Total_sales DESC
			OFFSET 0 ROWS)

SELECT a.ProductID, d.Name AS Category_name, c.Name AS Subcategory_name, b.Name AS Product_name, a.Total_sales
FROM a
LEFT JOIN Production.Product AS b
ON a.ProductID = b.ProductID
LEFT JOIN Production.ProductSubcategory AS c
ON b.ProductSubcategoryID = c.ProductSubcategoryID
LEFT JOIN Production.ProductCategory AS d
ON c.ProductCategoryID = d.ProductCategoryID;

---------------------------------------------------

---6️ Employee Performance (Sales Staff)

---Question:“Show me each salesperson’s total sales and the number of orders they handled in the past 6 months.”

WITH a AS (SELECT SalesPersonID, SUM(SubTotal) AS Total_sales, COUNT(SalesOrderID) AS Orders_handled
FROM Sales.SalesOrderHeader
WHERE OrderDate >= '2014-01-01' AND OnlineOrderFlag = 0
GROUP BY SalesPersonID
ORDER BY Total_sales DESC, Orders_handled DESC
OFFSET 0 ROWS)

SELECT	a.SalesPersonID,
		b.FirstName + ' ' + ISNULL(b.MiddleName + '. ','')+ b.LastName AS Employee_fullname,
		a.Total_sales,
		a.Orders_handled
FROM a
LEFT JOIN Person.Person AS b
ON a.SalesPersonID = b.BusinessEntityID;

---------------------------------------------------

---7️ Repeat Customers

---Question:“How many customers placed more than one order in the last year?”

--> assumption: last year = 2013

SELECT COUNT(*) AS num_of_repeat_customer
FROM (SELECT DISTINCT CustomerID AS num_purchases
		FROM SALES.SalesOrderHeader
		WHERE YEAR(OrderDate) = '2013'
		GROUP BY CustomerID
		HAVING COUNT(CustomerID) >= 2) AS a

---------------------------------------------------

---8️ Shipping & Fulfillment

---Question:“Give me the average days between order date and ship date by territory.”

SELECT b.Name AS Territory_name,
		AVG(DATEDIFF(DAY, OrderDate, ShipDate)) AS AvgDeliveryDays
FROM Sales.SalesOrderHeader AS a
LEFT JOIN Sales.SalesTerritory AS b
ON a.TerritoryID = b.TerritoryID
GROUP BY b.Name
ORDER BY Territory_name;

---------------------------------------------------

---9️ Profitability

---Question:“Estimate gross profit by product for last year.”

WITH c AS(SELECT	b.ProductSubcategoryID,
		b.Name AS ProductName,
		SUM((a.UnitPrice-b.StandardCost)*a.OrderQty) AS GrossProfit
FROM Sales.SalesOrderDetail AS a
LEFT JOIN Production.Product AS b
ON a.ProductID = b.ProductID
GROUP BY b.Name, b.ProductSubcategoryID)

SELECT e.Name AS Category, d.Name AS Subcategory, c.ProductName, c.GrossProfit
FROM c
LEFT JOIN Production.ProductSubcategory AS d
ON c.ProductSubcategoryID = d.ProductSubcategoryID
LEFT JOIN Production.ProductCategory AS e
ON d.ProductCategoryID = e.ProductCategoryID
ORDER BY Category, Subcategory,ProductName,GrossProfit;

---------------------------------------------------

---10 Inventory

---Question:“Which products are out of stock or have less than 10 units available?”

WITH a AS (SELECT ProductID, SUM(Quantity) AS TotalQty
FROM PRODUCTION.ProductInventory
GROUP BY ProductID
HAVING SUM(Quantity) <= 10)

SELECT d.Name AS Category, c.Name AS Subcategory,b.Name AS ProductName, a.TotalQty
FROM a
LEFT JOIN Production.Product AS b
ON a.ProductID = b.ProductID
LEFT JOIN Production.ProductSubcategory AS c
ON c.ProductSubcategoryID = b.ProductSubcategoryID
LEFT JOIN Production.ProductCategory AS d
ON c.ProductCategoryID = d.ProductCategoryID

---------------------------------------------------

