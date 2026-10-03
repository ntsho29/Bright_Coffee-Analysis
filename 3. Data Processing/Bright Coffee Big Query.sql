-- Databricks notebook source
CREATE OR REPLACE TABLE bright_coffee.coffeetable.bright_coffee_sales AS

SELECT

    transaction_id,

    transaction_date,

    time_of_day,

    transaction_qty,

    store_id,

    product_id,

    product_type,

    product_detail,

    -- Standardize unit price
    CAST(
        REPLACE(unit_price, ',', '.')
        AS DECIMAL(10,2)
    ) AS Unit_price_standardized,

    -- Calculate total amount correctly
    CAST(
        REPLACE(unit_price, ',', '.')
        AS DECIMAL(10,2)
    ) * transaction_qty AS total_amount,

    -- Date-related fields must use transaction_date
    DATE_FORMAT(transaction_date, 'EEEE') AS Day_Name,

    DATE_FORMAT(transaction_date, 'MMMM') AS Month_Name,

    YEAR(transaction_date) AS Transaction_Year,

    DAY(transaction_date) AS Transaction_Day,

    -- Time-related field uses time_of_day
    CAST(SUBSTRING(time_of_day, 1, 2) AS INT) AS Hour_of_the_Day,

    -- Weekday / Weekend classification
    CASE
        WHEN DATE_FORMAT(transaction_date, 'EEEE')
             IN ('Saturday', 'Sunday')
        THEN 'Weekend'
        ELSE 'Weekday'
    END AS Day_Classification,

    
    -- 3-hour time bucket
CASE
    WHEN CAST(SUBSTRING(time_of_day, 1, 2) AS INT) BETWEEN 0 AND 2 THEN '00:00-02:59'
    WHEN CAST(SUBSTRING(time_of_day, 1, 2) AS INT) BETWEEN 3 AND 5 THEN '03:00-05:59'
    WHEN CAST(SUBSTRING(time_of_day, 1, 2) AS INT) BETWEEN 6 AND 8 THEN '06:00-08:59'
    WHEN CAST(SUBSTRING(time_of_day, 1, 2) AS INT) BETWEEN 9 AND 11 THEN '09:00-11:59'
    WHEN CAST(SUBSTRING(time_of_day, 1, 2) AS INT) BETWEEN 12 AND 14 THEN '12:00-14:59'
    WHEN CAST(SUBSTRING(time_of_day, 1, 2) AS INT) BETWEEN 15 AND 17 THEN '15:00-17:59'
    WHEN CAST(SUBSTRING(time_of_day, 1, 2) AS INT) BETWEEN 18 AND 20 THEN '18:00-20:59'
    WHEN CAST(SUBSTRING(time_of_day, 1, 2) AS INT) BETWEEN 21 AND 23 THEN '21:00-23:59'
END AS Time_Bucket,

-- Descriptive time period
CASE
    WHEN CAST(SUBSTRING(time_of_day, 1, 2) AS INT) BETWEEN 0 AND 2 THEN 'Midnight'
    WHEN CAST(SUBSTRING(time_of_day, 1, 2) AS INT) BETWEEN 3 AND 5 THEN 'Early Morning'
    WHEN CAST(SUBSTRING(time_of_day, 1, 2) AS INT) BETWEEN 6 AND 8 THEN 'Morning'
    WHEN CAST(SUBSTRING(time_of_day, 1, 2) AS INT) BETWEEN 9 AND 11 THEN 'Late Morning'
    WHEN CAST(SUBSTRING(time_of_day, 1, 2) AS INT) BETWEEN 12 AND 14 THEN 'Afternoon'
    WHEN CAST(SUBSTRING(time_of_day, 1, 2) AS INT) BETWEEN 15 AND 17 THEN 'Late Afternoon'
    WHEN CAST(SUBSTRING(time_of_day, 1, 2) AS INT) BETWEEN 18 AND 20 THEN 'Evening'
    WHEN CAST(SUBSTRING(time_of_day, 1, 2) AS INT) BETWEEN 21 AND 23 THEN 'Night'
END AS Time_Period

FROM bright_coffee.coffeetable.bright_coffee_sales;

SELECT *
FROM bright_coffee.coffeetable.bright_coffee_sales;