-- Databricks notebook source
SELECT *
FROM bright_coffee.coffeetable.bright_coffee_sales
LIMIT 100;

DESCRIBE bright_coffee.coffeetable.bright_coffee_sales;

---------------cHECKING THE TYPES OF PRODUCTS WE HAVE--------
SELECT DISTINCT product_category
FROM bright_coffee.coffeetable.bright_coffee_sales;


----------CHECKIN PRODUCT TYPES
SELECT DISTINCT product_type
FROM bright_coffee.coffeetable.bright_coffee_sales;

----CLEANING PRODUCT CATEORY---
SELECT DISTINCT 
    product_category,
    CASE
        WHEN product_category IS NULL THEN 'Unknown'
        WHEN product_category = ' ' THEN 'Unknown'
    ELSE product_category
END AS Product_Category
FROM bright_coffee.coffeetable.bright_coffee_sales;


------INPECTING PRODUCT TYPE
SELECT DISTINCT 
    product_type,
    CASE
        WHEN product_type IS NULL THEN 'Unknown'
        WHEN product_type = ' ' THEN 'Unknown'
    ELSE product_type
END AS Product_Type
FROM bright_coffee.coffeetable.bright_coffee_sales;

--------Creating the revenue Column
SELECT transaction_qty,
        product_type,
        product_category,
        unit_price,
        (transaction_qty*unit_price) AS Total_Amount
FROM bright_coffee.coffeetable.bright_coffee_sales;


SELECT transaction_qty,
        product_type,
        product_category,
       unit_price,
       ROUND(SUM(unit_price*transaction_qty),2) AS Total_Amount
FROM bright_coffee.coffeetable.bright_coffee_sales
GROUP BY transaction_qty,unit_price,product_category,product_type;

SELECT COUNT(DISTINCT product_category) AS category_count,transaction_qty,
        product_type, unit_price
FROM bright_coffee.coffeetable.bright_coffee_sales
GROUP BY transaction_qty, unit_price,product_type,
        product_category;


---------TOTALSUM OF EACH PRODUCT CATEGORY-----
SELECT product_category, ROUND(SUM(unit_price*transaction_qty),2) AS Total_revenue
FROM bright_coffee.coffeetable.bright_coffee_sales
GROUP BY product_category
ORDER BY Total_revenue DESC;

---------TOTALSUM OF EACH PRODUCT TYPE-----
SELECT product_type, ROUND(SUM(unit_price*transaction_qty),2) AS Total_revenue
FROM bright_coffee.coffeetable.bright_coffee_sales
GROUP BY product_type
ORDER BY Total_revenue DESC;

-----CONVERTING THE DECIMAL COLUMN TO A WHOLE NUMBER
SELECT transaction_qty, ROUND (SUM (CAST(transaction_qty AS DOUBLE) * CAST (REPLACE(unit_price,',','.')AS DOUBLE)), 0) AS Total_Amount
FROM bright_coffee.coffeetable.bright_coffee_sales
GROUP BY transaction_qty;

---------------------------------------------------------------------------------------------------
--DATA CLEANING
---------------------------------------------------------------------------------------------

--Checking duplicates
SELECT DISTINCT transaction_id,
        COUNT(*) AS Duplicate_cnt
FROM bright_coffee.coffeetable.bright_coffee_sales
GROUP BY transaction_id
HAVING COUNT(*)
ORDER BY Duplicate_cnt DESC; 

SELECT transaction_id,
        COUNT(*) AS Duplicate_cnt
FROM bright_coffee.coffeetable.bright_coffee_sales
GROUP BY transaction_id
HAVING COUNT(*)>1;


--FINAL CODE FOR CHECKING DUPLICATES FOR ALL COLUMNS
SELECT *,
        COUNT(*) AS Duplicate_cnt
FROM bright_coffee.coffeetable.bright_coffee_sales
GROUP BY ALL
HAVING COUNT(*)>1;

--CHECKING THE DATE COLUMN
----
SELECT DISTINCT transaction_date
FROM bright_coffee.coffeetable.bright_coffee_sales;

-------IDENTIFYING THE MONTHS ON TRANSACTION DATE
SELECT DISTINCT DATE_FORMAT(transaction_date, 'MMMM') AS Month_name
FROM bright_coffee.coffeetable.bright_coffee_sales;

--CHECKING TRANCTION TIME COLUMN
SELECT DISTINCT transaction_time
FROM bright_coffee.coffeetable.bright_coffee_sales;

-------CHANING  THE TIME FORMAT ON TRANSACTION TIME
SELECT DISTINCT DATE_FORMAT(transaction_time, 'HH:MM:SS') AS Time
FROM bright_coffee.coffeetable.bright_coffee_sales;

SELECT
  CASE 
    WHEN HOUR(transaction_time) BETWEEN 7 AND 9 THEN 'Morning'
    WHEN HOUR(transaction_time) BETWEEN 10 AND 12 THEN 'Afternoon'
    WHEN HOUR(transaction_time) BETWEEN 13 AND 15 THEN 'Evening'
    WHEN HOUR(transaction_time) BETWEEN 16 AND 18 THEN 'Night'
    WHEN HOUR(transaction_time) >= 19 AND HOUR(transaction_time) <= 20 THEN 'Closing hours'
    ELSE 'Night'
  END AS Time_bucket
FROM bright_coffee.coffeetable.bright_coffee_sales;

-- ANALYSING REVENUE BY TIME BUCKET
 SELECT
  CASE 
    WHEN HOUR(transaction_time) BETWEEN 7 AND 9 THEN 'Morning'
    WHEN HOUR(transaction_time) BETWEEN 10 AND 12 THEN 'Afternoon'
    WHEN HOUR(transaction_time) BETWEEN 13 AND 15 THEN 'Evening'
    WHEN HOUR(transaction_time) BETWEEN 16 AND 18 THEN 'Night'
    WHEN HOUR(transaction_time) >= 19 AND HOUR(transaction_time) <= 20 THEN 'Closing hours'
    ELSE 'Night'
  END AS Time_bucket,
  SUM(unit_price * transaction_qty) AS Total_revenue
FROM bright_coffee.coffeetable.bright_coffee_sales
GROUP BY Time_bucket
ORDER BY Total_revenue DESC;

--checking total revenue per store location
SELECT store_location, SUM(unit_price * transaction_qty) AS Total_revenue
FROM bright_coffee.coffeetable.bright_coffee_sales
GROUP BY store_location
ORDER BY Total_revenue DESC;

--checking high performing and low performing products
SELECT
       MAX (transaction_qty * unit_price) AS Highest_product,
       MIN (transaction_qty * unit_price) AS Lowest_product
FROM bright_coffee.coffeetable.bright_coffee_sales;

--checking total revenue per store location
SELECT store_location, SUM(unit_price * transaction_qty) AS Total_revenue
FROM bright_coffee.coffeetable.bright_coffee_sales
GROUP BY store_location
ORDER BY Total_revenue DESC;

--checking high performing and low performing products
SELECT product_category, SUM(unit_price * transaction_qty) AS Total_revenue
FROM bright_coffee.coffeetable.bright_coffee_sales
GROUP BY product_category
ORDER BY Total_revenue DESC;

--checking high performing and low performing products
SELECT product_type, SUM(unit_price * transaction_qty) AS Total_revenue
FROM bright_coffee.coffeetable.bright_coffee_sales
GROUP BY product_type
ORDER BY Total_revenue DESC;

---Checking the days---
SELECT
    CASE 
    WHEN DAYOFWEEK(transaction_date) = 1 THEN 'Sunday'
    WHEN DAYOFWEEK(transaction_date) = 2 THEN 'Monday'
    WHEN DAYOFWEEK(transaction_date) = 3 THEN 'Tuesday'
    WHEN DAYOFWEEK(transaction_date) = 4 THEN 'Wednesday'
    WHEN DAYOFWEEK(transaction_date) = 5 THEN 'Thursday'
    WHEN DAYOFWEEK(transaction_date) = 6 THEN 'Friday'
    WHEN DAYOFWEEK(transaction_date) = 7 THEN 'Saturday'
    END AS Day_type
FROM bright_coffee.coffeetable.bright_coffee_sales;

--CREATING CTE TABLE
with
  sales_cte AS (
    SELECT
      *,
      CASE
        WHEN DAYOFWEEK(transaction_date) = 1 THEN 'Sunday'
        WHEN DAYOFWEEK(transaction_date) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(transaction_date)  = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(transaction_date) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(transaction_date) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(transaction_date) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(transaction_date) = 7 THEN 'Saturday'
      END AS Day_of_week,
      CASE
        WHEN HOUR(transaction_time) BETWEEN 7 AND 9 THEN 'Morning'
        WHEN HOUR(transaction_time) BETWEEN 10 AND 12 THEN 'Morning'
        WHEN HOUR(transaction_time) BETWEEN 13 AND 15 THEN 'Afternoon'
        WHEN   HOUR(transaction_time) BETWEEN 16 AND 18 THEN 'Evening'
        WHEN HOUR(transaction_time) >= 19 AND HOUR(transaction_time) <= 20 THEN 'Closing hours'
        ELSE 'Night'
      END AS Time_bucket
    FROM bright_coffee.coffeetable.bright_coffee_sales
  )

SELECT *
FROM sales_cte;

SELECT
    transaction_time,
    HOUR(transaction_time) AS transaction_hour,
    CASE
        WHEN HOUR(transaction_time) BETWEEN 6 AND 8 THEN '06:00–09:00'
        WHEN HOUR(transaction_time) BETWEEN 9 AND 11 THEN '09:00–12:00'
        WHEN HOUR(transaction_time) BETWEEN 12 AND 14 THEN '12:00–15:00'
        WHEN HOUR(transaction_time) BETWEEN 15 AND 17 THEN '15:00–18:00'
        WHEN HOUR(transaction_time) BETWEEN 18 AND 20 THEN '18:00–21:00'
    END AS transaction_time_bucket
FROM bright_coffee_case_study.default._bright_coffee_shop_dataset;

--Checking the Sales Value Category-----------------------------
SELECT
MAX (transaction_qty * unit_price) AS High_sales_value,
MIN (transaction_qty * unit_price) AS Low_sales_value
FROM  bright_coffee_case_study.default._bright_coffee_shop_dataset;

----------------------------------------------------------------------------------------------------------------
SELECT
CASE 
    WHEN (unit_price * transaction_qty) > 10000 THEN 'high'
    WHEN (unit_price * transaction_qty) BETWEEN 5000 AND 10000 THEN 'Medium'
    ELSE 'Very Low'
END AS Sales_Value_Category
FROM bright_coffee_case_study.default._bright_coffee_shop_dataset;
----------------------------------------------------------------------------------------------------------------
--Quantity Category
SELECT
CASE 
    WHEN transaction_qty =1 THEN 'low'
    WHEN transaction_qty BETWEEN 2 AND 3 THEN 'Medium'
    ELSE 'high'
END AS Quantity_Category
FROM bright_coffee_case_study.default._bright_coffee_shop_dataset;
----------------------------------------------------------------------------------------------------------------
--Quantity Category
SELECT
CASE 
    WHEN transaction_qty BETWEEN 1 AND 50 THEN 'low'
    WHEN transaction_qty BETWEEN 50 AND 100 THEN 'Medium'
    ELSE 'Very Low'

    