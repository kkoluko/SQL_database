--COUNT
-- Detecting products in Category

SELECT PROD_CATEGORY, COUNT(*) AS CountOfProducts_InCategory
FROM PRODUCTS
GROUP BY PROD_CATEGORY;

--Min, MAX, AVG

SELECT O.STORE_ID, O.ORDER_ID, O.ORDER_AMOUNT, AVG(O.ORDER_AMOUNT) OVER () AS AvgOrderAmount
FROM ORDERS O
WHERE O.ORDER_AMOUNT  > (SELECT AVG(ORDER_AMOUNT) FROM ORDERS);

SELECT MAX(ORDER_AMOUNT) AS MaxOrder, MIN (ORDER_AMOUNT) AS MinOrder, ROUND(AVG(ORDER_AMOUNT),2) AS AvgOrder
FROM ORDERS;

--CASE WHEN 
--Orders� classification

SELECT ORDER_DATE, ORDER_ID, ORDER_AMOUNT,
 CASE 
	WHEN ORDER_AMOUNT <= 6000 THEN 'SmallOrder'
	WHEN ORDER_AMOUNT > 6500 AND ORDER_AMOUNT <= 12000 THEN 'AverageOrder'
	ELSE 'LargeOrder'
END AS OrderClass
FROM ORDERS;
--Count of orders in each class

SELECT OrderClass, COUNT(*) AS OrderCount
FROM (
    SELECT 
    CASE 
        WHEN ORDER_AMOUNT <= 6000 THEN 'SmallOrder'
        WHEN ORDER_AMOUNT > 6000 AND ORDER_AMOUNT <= 12000 THEN 'AverageOrder'
        ELSE 'LargeOrder'
    END AS OrderClass
    FROM ORDERS
) AS OrderClassTable
GROUP BY OrderClass
ORDER BY OrderCount DESC;
--SELECT AND JOIN TABLES 
-- selecting fruits, fruits' suppliers and their countries for Fruits

SELECT P.PROD_NAME, S.SUPL_NAME, C.COUNTRY_NAME
FROM PRODUCTS P
LEFT JOIN SUPPLIERS S on P.SPL_ID = S.SPL_ID 
LEFT JOIN COUNTRY C on S.SUPL_REG_COUNTRY = C.COUNTRY_CODE
WHERE P.PROD_CATEGORY = 'Fruits';

--  calculating total order amount for each Reteiler

SELECT R.STORE_NAME, SUM(O.ORDER_AMOUNT) AS TOTAL
FROM RETAILERS R
RIGHT JOIN ORDERS O on R.STORE_ID = O.STORE_ID
GROUP BY R.STORE_NAME
ORDER BY TOTAL DESC;

-- Calculating TotalOrdersAmount for every Months

SELECT MONTH(ORDER_DATE) AS OrderMonth, SUM(ORDER_AMOUNT) AS TotalOrderAmount
FROM ORDERS
GROUP BY MONTH(ORDER_DATE);


--CALCULATION AND JOINING TABLES 

-- Products Ordered Quantity and Orders Amount

SELECT P.PROD_ID, 
P.PROD_NAME, 
SUM(OD.ORDERED_QTITY) AS TotalOrderedQuantity, 
P.UNIT, 
SUM(OD.TOTAL_AMOUNT) AS TotalOrdersAmount
FROM ORDER_DETAILS OD
LEFT JOIN PRODUCTS P on OD.PRODUCT_ID = P.PROD_ID
GROUP BY P.PROD_ID, P.PROD_NAME, P.UNIT
ORDER BY SUM(OD.ORDERED_QTITY) DESC;

-- Revenue for each Product by Month

SELECT P.PROD_ID, 
	MONTH(O.ORDER_DATE) AS ORDER_MONTH,
	P.PROD_NAME, 
	SUM(OD.ORDERED_QTITY) AS TotalOrderedQuantity, 
	P.UNIT, 
	SUM(OD.TOTAL_AMOUNT) AS TotalOrdersAmount, 
	SUM(OD.ORDERED_QTITY*P.MAN_UNIT_PRICE) AS ProdExpences,
	SUM(OD.TOTAL_AMOUNT) - SUM(OD.ORDERED_QTITY*P.MAN_UNIT_PRICE) AS Revenue
FROM ORDER_DETAILS OD
	LEFT JOIN PRODUCTS P on OD.PRODUCT_ID = P.PROD_ID
	LEFT JOIN ORDERS O on OD.ORDER_ID = O.ORDER_ID
GROUP BY P.PROD_ID, 
	MONTH(O.ORDER_DATE),
	P.PROD_NAME,
	P.UNIT
ORDER BY ORDER_MONTH ASC;

-- Revenue FOR every MONTH

SELECT 
    MONTH(O.ORDER_DATE) AS ORDER_MONTH,
    SUM(OD.TOTAL_AMOUNT) AS TotalOrdersAmount, 
    SUM(OD.ORDERED_QTITY * P.MAN_UNIT_PRICE) AS TotalExpenses,
    SUM(OD.TOTAL_AMOUNT) - SUM(OD.ORDERED_QTITY * P.MAN_UNIT_PRICE) AS Revenue
FROM 
    ORDER_DETAILS AS OD
LEFT JOIN 
    PRODUCTS AS P ON OD.PRODUCT_ID = P.PROD_ID
LEFT JOIN 
    ORDERS AS O ON OD.ORDER_ID = O.ORDER_ID
GROUP BY 
    MONTH(O.ORDER_DATE)
ORDER BY 
    ORDER_MONTH;


-- Revenue for each Product

SELECT P.PROD_ID, 
	P.PROD_NAME, 
	SUM(OD.ORDERED_QTITY) AS TotalOrderedQuantity, 
	P.UNIT, 
	SUM(OD.TOTAL_AMOUNT) AS TotalOrdersAmount, 
	SUM(OD.ORDERED_QTITY*P.MAN_UNIT_PRICE) AS ProdExpences,
	SUM(OD.TOTAL_AMOUNT) - SUM(OD.ORDERED_QTITY *P.MAN_UNIT_PRICE) AS Revenue
FROM ORDER_DETAILS OD
	LEFT JOIN PRODUCTS P on OD.PRODUCT_ID = P.PROD_ID
GROUP BY P.PROD_ID, 
	P.PROD_NAME, 
	P.UNIT
ORDER BY Revenue DESC;

-- Revenue for each Reteiler

SELECT	R.STORE_NAME, 
		SUM(OD.TOTAL_AMOUNT) AS TotalOrdersAmount,
		SUM(OD.ORDERED_QTITY*P.MAN_UNIT_PRICE) AS ProdExpences,
		SUM(OD.TOTAL_AMOUNT) - SUM(OD.ORDERED_QTITY *P.MAN_UNIT_PRICE) AS Revenue
FROM RETAILERS R
		LEFT JOIN ORDERS O on R.STORE_ID = O.STORE_ID
		LEFT JOIN ORDER_DETAILS OD on O.ORDER_ID = OD.ORDER_ID
		LEFT JOIN PRODUCTS P on OD.PRODUCT_ID = P.PROD_ID
GROUP BY R.STORE_NAME
ORDER BY Revenue DESC;

-- Revenue and Turnover for each Country

SELECT	C.COUNTRY_NAME, 
	SUM(OD.TOTAL_AMOUNT) AS TotalOrdersAmount,
	SUM(OD.ORDERED_QTITY * P.MAN_UNIT_PRICE) AS ProdExpences,
	SUM(OD.TOTAL_AMOUNT) - SUM(OD.ORDERED_QTITY*P.MAN_UNIT_PRICE) AS Revenue
FROM RETAILERS R
	LEFT JOIN ORDERS O on R.STORE_ID = O.STORE_ID
	LEFT JOIN ORDER_DETAILS OD on O.ORDER_ID = OD.ORDER_ID
	LEFT JOIN PRODUCTS P on OD.PRODUCT_ID = P.PROD_ID
	LEFT JOIN COUNTRY C on R.STORE_COUNTRY = c.COUNTRY_CODE
GROUP BY C.COUNTRY_NAME
ORDER BY Revenue DESC;


--Revenue for each channel level

SELECT	R.CHANNEL_LEVEL,
	SUM(OD.TOTAL_AMOUNT) AS TotalOrdersAmount,
	SUM(OD.ORDERED_QTITY * P.MAN_UNIT_PRICE) AS ProdExpences,
	SUM(OD.TOTAL_AMOUNT) - SUM(OD.ORDERED_QTITY*P.MAN_UNIT_PRICE) AS Revenue
FROM RETAILERS R
	LEFT JOIN ORDERS O on R.STORE_ID = O.STORE_ID
	LEFT JOIN ORDER_DETAILS OD on O.ORDER_ID = OD.ORDER_ID
	LEFT JOIN PRODUCTS P on OD.PRODUCT_ID = P.PROD_ID
GROUP BY R.CHANNEL_LEVEL
ORDER BY Revenue DESC;
--PIVOT TABLES 

--Revenue in PIVOT table for each channel level and month
SELECT
    R.CHANNEL_LEVEL,
    SUM(CASE WHEN MONTH(O.ORDER_DATE) = 1 THEN OD.TOTAL_AMOUNT - OD.ORDERED_QTITY * P.MAN_UNIT_PRICE ELSE 0 END) AS Revenue_Jan,
    SUM(CASE WHEN MONTH(O.ORDER_DATE) = 2 THEN OD.TOTAL_AMOUNT - OD.ORDERED_QTITY * P.MAN_UNIT_PRICE ELSE 0 END) AS Revenue_Feb,
    SUM(CASE WHEN MONTH(O.ORDER_DATE) = 3 THEN OD.TOTAL_AMOUNT - OD.ORDERED_QTITY * P.MAN_UNIT_PRICE ELSE 0 END) AS Revenue_Mar,
    SUM(CASE WHEN MONTH(O.ORDER_DATE) = 4 THEN OD.TOTAL_AMOUNT - OD.ORDERED_QTITY * P.MAN_UNIT_PRICE ELSE 0 END) AS Revenue_Apr,
    SUM(CASE WHEN MONTH(O.ORDER_DATE) = 5 THEN OD.TOTAL_AMOUNT - OD.ORDERED_QTITY * P.MAN_UNIT_PRICE ELSE 0 END) AS Revenue_May,
    SUM(CASE WHEN MONTH(O.ORDER_DATE) = 6 THEN OD.TOTAL_AMOUNT - OD.ORDERED_QTITY * P.MAN_UNIT_PRICE ELSE 0 END) AS Revenue_Jun,
    SUM(CASE WHEN MONTH(O.ORDER_DATE) = 7 THEN OD.TOTAL_AMOUNT - OD.ORDERED_QTITY * P.MAN_UNIT_PRICE ELSE 0 END) AS Revenue_Jul,
    SUM(CASE WHEN MONTH(O.ORDER_DATE) = 8 THEN OD.TOTAL_AMOUNT - OD.ORDERED_QTITY * P.MAN_UNIT_PRICE ELSE 0 END) AS Revenue_Aug,
    SUM(CASE WHEN MONTH(O.ORDER_DATE) = 9 THEN OD.TOTAL_AMOUNT - OD.ORDERED_QTITY * P.MAN_UNIT_PRICE ELSE 0 END) AS Revenue_Sep,
    SUM(CASE WHEN MONTH(O.ORDER_DATE) = 10 THEN OD.TOTAL_AMOUNT - OD.ORDERED_QTITY * P.MAN_UNIT_PRICE ELSE 0 END) AS Revenue_Oct,
    SUM(CASE WHEN MONTH(O.ORDER_DATE) = 11 THEN OD.TOTAL_AMOUNT - OD.ORDERED_QTITY * P.MAN_UNIT_PRICE ELSE 0 END) AS Revenue_Nov,
    SUM(CASE WHEN MONTH(O.ORDER_DATE) = 12 THEN OD.TOTAL_AMOUNT - OD.ORDERED_QTITY * P.MAN_UNIT_PRICE ELSE 0 END) AS Revenue_Dec,
    SUM(OD.TOTAL_AMOUNT - OD.ORDERED_QTITY * P.MAN_UNIT_PRICE) AS Revenue_AllMonths
	
FROM 
    RETAILERS R
LEFT JOIN 
    ORDERS O ON R.STORE_ID = O.STORE_ID
RIGHT JOIN 
    ORDER_DETAILS OD ON O.ORDER_ID = OD.ORDER_ID
LEFT JOIN 
    PRODUCTS P ON OD.PRODUCT_ID = P.PROD_ID
GROUP BY 
    R.CHANNEL_LEVEL
ORDER BY 
    R.CHANNEL_LEVEL;

-- Orders Amount in PIVOT table for each channel level and month
SELECT
    R.CHANNEL_LEVEL,
    SUM(CASE WHEN MONTH(O.ORDER_DATE) = 1 THEN OD.TOTAL_AMOUNT ELSE 0 END) AS TotalOrdersAmount_Jan,
    SUM(CASE WHEN MONTH(O.ORDER_DATE) = 2 THEN OD.TOTAL_AMOUNT ELSE 0 END) AS TotalOrdersAmount_Feb,
    SUM(CASE WHEN MONTH(O.ORDER_DATE) = 3 THEN OD.TOTAL_AMOUNT ELSE 0 END) AS TotalOrdersAmount_Mar,
    SUM(CASE WHEN MONTH(O.ORDER_DATE) = 4 THEN OD.TOTAL_AMOUNT ELSE 0 END) AS TotalOrdersAmount_Apr,
    SUM(CASE WHEN MONTH(O.ORDER_DATE) = 5 THEN OD.TOTAL_AMOUNT ELSE 0 END) AS TotalOrdersAmount_May,
    SUM(CASE WHEN MONTH(O.ORDER_DATE) = 6 THEN OD.TOTAL_AMOUNT ELSE 0 END) AS TotalOrdersAmount_Jun,
    SUM(CASE WHEN MONTH(O.ORDER_DATE) = 7 THEN OD.TOTAL_AMOUNT ELSE 0 END) AS TotalOrdersAmount_Jul,
    SUM(CASE WHEN MONTH(O.ORDER_DATE) = 8 THEN OD.TOTAL_AMOUNT ELSE 0 END) AS TotalOrdersAmount_Aug,
    SUM(CASE WHEN MONTH(O.ORDER_DATE) = 9 THEN OD.TOTAL_AMOUNT ELSE 0 END) AS TotalOrdersAmount_Sep,
    SUM(CASE WHEN MONTH(O.ORDER_DATE) = 10 THEN OD.TOTAL_AMOUNT ELSE 0 END) AS TotalOrdersAmount_Oct,
    SUM(CASE WHEN MONTH(O.ORDER_DATE) = 11 THEN OD.TOTAL_AMOUNT ELSE 0 END) AS TotalOrdersAmount_Nov,
    SUM(CASE WHEN MONTH(O.ORDER_DATE) = 12 THEN OD.TOTAL_AMOUNT ELSE 0 END) AS TotalOrdersAmount_Dec,
    SUM(OD.TOTAL_AMOUNT) AS TotalOrdersAmount_AllMonths
  
FROM 
    RETAILERS R
LEFT JOIN 
    ORDERS O ON R.STORE_ID = O.STORE_ID
RIGHT JOIN 
    ORDER_DETAILS OD ON O.ORDER_ID = OD.ORDER_ID
LEFT JOIN 
    PRODUCTS P ON OD.PRODUCT_ID = P.PROD_ID
GROUP BY 
    R.CHANNEL_LEVEL
ORDER BY 
    R.CHANNEL_LEVEL;

-- Expences in PIVOT table for each channel level and month
SELECT
    R.CHANNEL_LEVEL,
    SUM(CASE WHEN MONTH(O.ORDER_DATE) = 1 THEN OD.ORDERED_QTITY * P.MAN_UNIT_PRICE ELSE 0 END) AS ProdExpenses_Jan,
    SUM(CASE WHEN MONTH(O.ORDER_DATE) = 2 THEN OD.ORDERED_QTITY * P.MAN_UNIT_PRICE ELSE 0 END) AS ProdExpenses_Feb,
    SUM(CASE WHEN MONTH(O.ORDER_DATE) = 3 THEN OD.ORDERED_QTITY * P.MAN_UNIT_PRICE ELSE 0 END) AS ProdExpenses_Mar,
    SUM(CASE WHEN MONTH(O.ORDER_DATE) = 4 THEN OD.ORDERED_QTITY * P.MAN_UNIT_PRICE ELSE 0 END) AS ProdExpenses_Apr,
    SUM(CASE WHEN MONTH(O.ORDER_DATE) = 5 THEN OD.ORDERED_QTITY * P.MAN_UNIT_PRICE ELSE 0 END) AS ProdExpenses_May,
    SUM(CASE WHEN MONTH(O.ORDER_DATE) = 6 THEN OD.ORDERED_QTITY * P.MAN_UNIT_PRICE ELSE 0 END) AS ProdExpenses_Jun,
    SUM(CASE WHEN MONTH(O.ORDER_DATE) = 7 THEN OD.ORDERED_QTITY * P.MAN_UNIT_PRICE ELSE 0 END) AS ProdExpenses_Jul,
    SUM(CASE WHEN MONTH(O.ORDER_DATE) = 8 THEN OD.ORDERED_QTITY * P.MAN_UNIT_PRICE ELSE 0 END) AS ProdExpenses_Aug,
    SUM(CASE WHEN MONTH(O.ORDER_DATE) = 9 THEN OD.ORDERED_QTITY * P.MAN_UNIT_PRICE ELSE 0 END) AS ProdExpenses_Sep,
    SUM(CASE WHEN MONTH(O.ORDER_DATE) = 10 THEN OD.ORDERED_QTITY * P.MAN_UNIT_PRICE ELSE 0 END) AS ProdExpenses_Oct,
    SUM(CASE WHEN MONTH(O.ORDER_DATE) = 11 THEN OD.ORDERED_QTITY * P.MAN_UNIT_PRICE ELSE 0 END) AS ProdExpenses_Nov,
    SUM(CASE WHEN MONTH(O.ORDER_DATE) = 12 THEN OD.ORDERED_QTITY * P.MAN_UNIT_PRICE ELSE 0 END) AS ProdExpenses_Dec,
    SUM(OD.ORDERED_QTITY * P.MAN_UNIT_PRICE) AS ProdExpenses_AllMonths
FROM 
    RETAILERS R
LEFT JOIN 
    ORDERS O ON R.STORE_ID = O.STORE_ID
RIGHT JOIN 
    ORDER_DETAILS OD ON O.ORDER_ID = OD.ORDER_ID
LEFT JOIN 
    PRODUCTS P ON OD.PRODUCT_ID = P.PROD_ID
GROUP BY 
    R.CHANNEL_LEVEL
ORDER BY 
    R.CHANNEL_LEVEL;
--VIEW and UNION
--Creation of view for each retailer by month in 2024

CREATE VIEW RevenueByReteilers2024 AS
SELECT
    R.STORE_NAME,
    SUM(CASE WHEN MONTH(O.ORDER_DATE) = 1 THEN OD.TOTAL_AMOUNT - OD.ORDERED_QTITY * P.MAN_UNIT_PRICE ELSE 0 END) AS Jan,
    SUM(CASE WHEN MONTH(O.ORDER_DATE) = 2 THEN OD.TOTAL_AMOUNT - OD.ORDERED_QTITY * P.MAN_UNIT_PRICE ELSE 0 END) AS Feb,
    SUM(CASE WHEN MONTH(O.ORDER_DATE) = 3 THEN OD.TOTAL_AMOUNT - OD.ORDERED_QTITY * P.MAN_UNIT_PRICE ELSE 0 END) AS Mar,
    SUM(CASE WHEN MONTH(O.ORDER_DATE) = 4 THEN OD.TOTAL_AMOUNT - OD.ORDERED_QTITY * P.MAN_UNIT_PRICE ELSE 0 END) AS Apr,
    SUM(CASE WHEN MONTH(O.ORDER_DATE) = 5 THEN OD.TOTAL_AMOUNT - OD.ORDERED_QTITY * P.MAN_UNIT_PRICE ELSE 0 END) AS May,
    SUM(CASE WHEN MONTH(O.ORDER_DATE) = 6 THEN OD.TOTAL_AMOUNT - OD.ORDERED_QTITY * P.MAN_UNIT_PRICE ELSE 0 END) AS Jun,
    SUM(CASE WHEN MONTH(O.ORDER_DATE) = 7 THEN OD.TOTAL_AMOUNT - OD.ORDERED_QTITY * P.MAN_UNIT_PRICE ELSE 0 END) AS Jul,
    SUM(CASE WHEN MONTH(O.ORDER_DATE) = 8 THEN OD.TOTAL_AMOUNT - OD.ORDERED_QTITY * P.MAN_UNIT_PRICE ELSE 0 END) AS Aug,
    SUM(CASE WHEN MONTH(O.ORDER_DATE) = 9 THEN OD.TOTAL_AMOUNT - OD.ORDERED_QTITY * P.MAN_UNIT_PRICE ELSE 0 END) AS Sep,
    SUM(CASE WHEN MONTH(O.ORDER_DATE) = 10 THEN OD.TOTAL_AMOUNT - OD.ORDERED_QTITY * P.MAN_UNIT_PRICE ELSE 0 END) AS Oct,
    SUM(CASE WHEN MONTH(O.ORDER_DATE) = 11 THEN OD.TOTAL_AMOUNT - OD.ORDERED_QTITY * P.MAN_UNIT_PRICE ELSE 0 END) AS Nov,
    SUM(CASE WHEN MONTH(O.ORDER_DATE) = 12 THEN OD.TOTAL_AMOUNT - OD.ORDERED_QTITY * P.MAN_UNIT_PRICE ELSE 0 END) AS Dec,
    SUM(OD.TOTAL_AMOUNT - OD.ORDERED_QTITY * P.MAN_UNIT_PRICE) AS TOTAL_YEAR
FROM 
    RETAILERS R
LEFT JOIN 
    ORDERS O ON R.STORE_ID = O.STORE_ID
RIGHT JOIN 
    ORDER_DETAILS OD ON O.ORDER_ID = OD.ORDER_ID
LEFT JOIN 
    PRODUCTS P ON OD.PRODUCT_ID = P.PROD_ID
WHERE YEAR(O.ORDER_DATE)=2024
GROUP BY 
    R.STORE_NAME

UNION ALL

SELECT
    'TOTAL_REVENUE' AS STORE_NAME,
    SUM(CASE WHEN MONTH(O.ORDER_DATE) = 1 THEN OD.TOTAL_AMOUNT - OD.ORDERED_QTITY * P.MAN_UNIT_PRICE ELSE 0 END) AS Jan,
    SUM(CASE WHEN MONTH(O.ORDER_DATE) = 2 THEN OD.TOTAL_AMOUNT - OD.ORDERED_QTITY * P.MAN_UNIT_PRICE ELSE 0 END) AS Feb,
    SUM(CASE WHEN MONTH(O.ORDER_DATE) = 3 THEN OD.TOTAL_AMOUNT - OD.ORDERED_QTITY * P.MAN_UNIT_PRICE ELSE 0 END) AS Mar,
    SUM(CASE WHEN MONTH(O.ORDER_DATE) = 4 THEN OD.TOTAL_AMOUNT - OD.ORDERED_QTITY * P.MAN_UNIT_PRICE ELSE 0 END) AS Apr,
    SUM(CASE WHEN MONTH(O.ORDER_DATE) = 5 THEN OD.TOTAL_AMOUNT - OD.ORDERED_QTITY * P.MAN_UNIT_PRICE ELSE 0 END) AS May,
    SUM(CASE WHEN MONTH(O.ORDER_DATE) = 6 THEN OD.TOTAL_AMOUNT - OD.ORDERED_QTITY * P.MAN_UNIT_PRICE ELSE 0 END) AS Jun,
    SUM(CASE WHEN MONTH(O.ORDER_DATE) = 7 THEN OD.TOTAL_AMOUNT - OD.ORDERED_QTITY * P.MAN_UNIT_PRICE ELSE 0 END) AS Jul,
    SUM(CASE WHEN MONTH(O.ORDER_DATE) = 8 THEN OD.TOTAL_AMOUNT - OD.ORDERED_QTITY * P.MAN_UNIT_PRICE ELSE 0 END) AS Aug,
    SUM(CASE WHEN MONTH(O.ORDER_DATE) = 9 THEN OD.TOTAL_AMOUNT - OD.ORDERED_QTITY * P.MAN_UNIT_PRICE ELSE 0 END) AS Sep,
    SUM(CASE WHEN MONTH(O.ORDER_DATE) = 10 THEN OD.TOTAL_AMOUNT - OD.ORDERED_QTITY * P.MAN_UNIT_PRICE ELSE 0 END) AS Oct,
    SUM(CASE WHEN MONTH(O.ORDER_DATE) = 11 THEN OD.TOTAL_AMOUNT - OD.ORDERED_QTITY * P.MAN_UNIT_PRICE ELSE 0 END) AS Nov,
    SUM(CASE WHEN MONTH(O.ORDER_DATE) = 12 THEN OD.TOTAL_AMOUNT - OD.ORDERED_QTITY * P.MAN_UNIT_PRICE ELSE 0 END) AS Dec,
    SUM(OD.TOTAL_AMOUNT - OD.ORDERED_QTITY * P.MAN_UNIT_PRICE) AS TOTAL_REVENUE
FROM 
    RETAILERS R
LEFT JOIN 
    ORDERS O ON R.STORE_ID = O.STORE_ID
RIGHT JOIN 
    ORDER_DETAILS OD ON O.ORDER_ID = OD.ORDER_ID
LEFT JOIN 
    PRODUCTS P ON OD.PRODUCT_ID = P.PROD_ID
WHERE YEAR(O.ORDER_DATE)=2024;

--Select from view	
SELECT * FROM RevenueByReteilers2024;

--Delete view
DROP VIEW RevenueByReteilers2024


--STORED PROCEDURE

-- sored procedure to retrieve data for specific order 
CREATE PROCEDURE OrderDetails
    @OrderID VARCHAR(9)
AS
BEGIN

SELECT O.ORDER_DATE, 
OD.ORDER_ID, 
R.STORE_NAME,  
OD.PRODUCT_ID, 
P.PROD_NAME, 
OD.ORDERED_QTITY, 
OD.UNIT_PRICE, 
P.UNIT, 
OD.TOTAL_AMOUNT
FROM ORDER_DETAILS OD
INNER JOIN PRODUCTS P on OD.PRODUCT_ID = P.PROD_ID
LEFT JOIN ORDERS O on OD.ORDER_ID =O.ORDER_ID
LEFT JOIN RETAILERS R on O.STORE_ID = R.STORE_ID

WHERE 
        OD.ORDER_ID = @OrderID
END

-- executing procedure
EXEC OrderDetails @OrderID = '@OrderID'

-- EXAML
EXEC OrderDetails @OrderID = 'ORD001'

--stored procedure to retrieve data for specific product by month

CREATE PROCEDURE Product_Revenue
    @ProdID CHAR(9)
AS
BEGIN
SELECT P.PROD_ID, 
	MONTH(O.ORDER_DATE) AS ORDER_MONTH,
	P.PROD_NAME, 
	SUM(OD.ORDERED_QTITY) AS TotalOrderedQuantity, 
	P.UNIT, 
	SUM(OD.TOTAL_AMOUNT) AS TotalOrdersAmount, 
	SUM(OD.ORDERED_QTITY*P.MAN_UNIT_PRICE) AS ProdExpences,
	SUM(OD.TOTAL_AMOUNT) - SUM(OD.ORDERED_QTITY*P.MAN_UNIT_PRICE) AS Revenue
FROM ORDER_DETAILS OD
	LEFT JOIN PRODUCTS P on OD.PRODUCT_ID = P.PROD_ID
	LEFT JOIN ORDERS O on OD.ORDER_ID = O.ORDER_ID
WHERE P.PROD_ID = @ProdID
GROUP BY P.PROD_ID, 
	MONTH(O.ORDER_DATE),
	P.PROD_NAME,
	P.UNIT
ORDER BY ORDER_MONTH ASC
END; 
-- executing procedure

EXEC Product_Revenue @ProdID = '@ProdID'

-- EXAML
EXEC Product_Revenue @ProdID = 'PROD1'

--Procedure to update the manufacturer�s price for a specific product by 20%

CREATE PROCEDURE Product_Price_Update
    @ProdID CHAR(9) 
AS
BEGIN
UPDATE PRODUCTS
SET MAN_UNIT_PRICE = MAN_UNIT_PRICE * 1.2
WHERE PROD_ID = @ProdID
END;
-- executing procedure

EXEC Product_Price_Update @ProdID = '@ProdID'

--EXEMPL

EXEC Product_Price_Update @ProdID = 'PROD1'
