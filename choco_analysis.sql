/* ================================================================
   PROJECT: Chocolate Sales Data Analysis   
   DATABASE: choco_db
   ================================================================ */

/* -------------------------
   1. DATABASE SETUP
      This project analyzes chocolate sales data stored in the choco_data table of the choco_db database.
   ------------------------- */


-- Create a new database
CREATE DATABASE choco_db;

-- Switch to the newly created database
USE choco_db;

-- Create the main table to store chocolate sales data
CREATE TABLE choco_data (
    Sales_Person      VARCHAR(100),
    Geography         VARCHAR(50),
    Product           VARCHAR(100),
    Amount            INT,
    Units             INT,
    cost_per_unit     INT,
    Cost              INT,
    Profit            INT,
    revenue_per_unit  INT,
    markup            INT
);

-- Display all records in the table
SELECT * FROM choco_data;

-- Show the structure of the table
DESC choco_data;


/* -------------------------
   2. ANALYSIS QUERIES
   ------------------------- */

-- Q1. Which sales person generated the highest total profit?
SELECT 
    Sales_Person, 
    SUM(Profit) AS Total_Profit
FROM choco_data
GROUP BY Sales_Person
ORDER BY Total_Profit DESC
LIMIT 1;


-- Q2. Top 5 Best-Selling Products (by total units sold)
SELECT 
    Product, 
    SUM(Units) AS Total_Units
FROM choco_data
GROUP BY Product
ORDER BY Total_Units DESC
LIMIT 5;


-- Q3. Find all sales in the USA where Profit is greater than 5000
SELECT 
    Sales_Person, 
    Geography, 
    Product, 
    Profit
FROM choco_data
WHERE Geography = 'USA'
  AND Profit > 5000;


-- Q4. Get records where revenue per unit is between 10 and 20, but geography is not UK
SELECT 
    Product, 
    Geography, 
    revenue_per_unit
FROM choco_data
WHERE revenue_per_unit BETWEEN 10 AND 20
  AND Geography <> 'UK';


-- Q5. List all products with negative profit (loss-making products)
SELECT 
    Product,
    Profit
FROM choco_data
WHERE Profit < 0;


-- Q6. Which geography contributes the most revenue?
SELECT 
    Geography, 
    SUM(Amount) AS Total_Revenue
FROM choco_data
GROUP BY Geography
ORDER BY Total_Revenue DESC;


-- Q7. Which product has the highest average profit per unit?
SELECT 
    Product, 
    AVG(Profit / Units) AS Avg_Profit_Per_Unit
FROM choco_data
GROUP BY Product
ORDER BY Avg_Profit_Per_Unit DESC;


-- Q8. Find pairs of salespersons from the same geography
SELECT 
    A.Sales_Person AS SalesPerson1,
    B.Sales_Person AS SalesPerson2,
    A.Geography
FROM choco_data A
JOIN choco_data B
    ON A.Geography = B.Geography
   AND A.Sales_Person < B.Sales_Person
ORDER BY A.Geography;


-- Q9. Top 3 products with the highest average profit per unit 
-- using a CTE
WITH ProfitPerUnit AS (
    SELECT 
        Product,
        SUM(Profit) * 1.0 / SUM(Units) AS Avg_Profit_Per_Unit
    FROM choco_data
    GROUP BY Product
)
SELECT 
    Product, 
    Avg_Profit_Per_Unit
FROM ProfitPerUnit
ORDER BY Avg_Profit_Per_Unit DESC
LIMIT 3;


-- Q10. Top 3 salespersons in each geography based on total revenue
--       using RANK()
SELECT 
    Geography,
    Sales_Person,
    SUM(Amount) AS Total_Revenue,
    RANK() OVER (
        PARTITION BY Geography 
        ORDER BY SUM(Amount) DESC
    ) AS Revenue_Rank
FROM choco_data
GROUP BY Geography, Sales_Person
LIMIT 3;


-- Q11. Rank products by average profit within each geography 
--       using DENSE_RANK()
SELECT 
    Geography,
    Product,
    AVG(Profit) AS Avg_Profit,
    DENSE_RANK() OVER (
        PARTITION BY Geography 
        ORDER BY AVG(Profit) DESC
    ) AS Profit_Rank
FROM choco_data
GROUP BY Geography, Product;


-- Q12. Assign a unique row number to every sale 
--      (ordered by profit within each salesperson)
SELECT 
    Sales_Person,
    Product,
    Profit,
    ROW_NUMBER() OVER (
        PARTITION BY Sales_Person 
        ORDER BY Profit DESC
    ) AS Sale_RowNum
FROM choco_data;


-- Q13. Find all products whose names contain the word "Choco"
SELECT 
    Product, 
    Amount, 
    Profit
FROM choco_data
WHERE Product LIKE '%Choco%';


-- Q14. Find products where the 2nd character is 'h'
SELECT 
    Product
FROM choco_data
WHERE Product LIKE '_h%';


-- Q15. Find salespersons named either “Ram Mahesh” or “Carla Molina”
SELECT 
    Sales_Person
FROM choco_data
WHERE Sales_Person IN ('Ram Mahesh', 'Carla Molina')
GROUP BY Sales_Person;

-------------------------------------------------------------------- END ---------------------------------------------------------------------
