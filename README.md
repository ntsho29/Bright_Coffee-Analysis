# ☕ Bright Coffee Shop Sales Analysis

# Lovable Dashboard : https://coffee-cues-dashboard.lovable.app

## 📊 Project Overview

This project analyses Bright Coffee Shop sales data to uncover sales patterns, product performance, revenue trends, and peak trading periods.

The project focuses on transforming raw transactional data into a cleaned analytical dataset and using SQL, Excel, and data visualisation tools to generate actionable business insights.

The analysis answers key business questions such as:

- Which products generate the most revenue?
- Which products sell the highest number of units?
- What times of day generate the most sales?
- Which product types perform best?
- How do sales differ between weekdays and weekends?
- What sales trends can be identified?
- Which areas of the business could benefit from targeted promotions or improved stock planning?

---

## 🎯 Business Objective

The objective of this project is to help Bright Coffee Shop understand its sales performance and make data-driven decisions.

The analysis focuses on:

- Revenue performance
- Product performance
- Sales volume
- Time-based sales patterns
- Day-of-week performance
- Weekday vs weekend performance
- Identifying high- and low-performing products
- Developing business recommendations based on the findings

---

## 🗂️ Dataset

The dataset contains transactional sales information from Bright Coffee Shop.

Key fields include:

| Field | Description |
|---|---|
| `transaction_id` | Unique identifier for each transaction |
| `transaction_date` | Date of the transaction |
| `time_of_day` | Time at which the transaction occurred |
| `transaction_qty` | Number of items sold |
| `store_id` | Store identifier |
| `product_id` | Product identifier |
| `product_type` | Type/category of product sold |
| `product_detail` | Specific product sold |
| `unit_price` | Price per unit |
| `total_amount` | Total transaction value |
| `Day_Name` | Day of the week |
| `Month_Name` | Month of the transaction |
| `Transaction_Year` | Year of the transaction |
| `Hour_of_the_Day` | Hour extracted from the transaction time |
| `Day_Classification` | Weekday or Weekend |
| `Time_Bucket` | Three-hour sales interval |
| `Time_Period` | Human-readable period such as Morning, Afternoon or Evening |

---

## 🧹 Data Cleaning & Transformation

The raw sales data was cleaned and transformed using SQL in Databricks.

Key transformations included:

- Standardising the `unit_price` field
- Converting comma-based decimal values into standard decimal values
- Calculating total transaction revenue
- Extracting the day of the week
- Extracting the month
- Extracting the transaction year
- Extracting the hour of the transaction
- Classifying transactions as Weekday or Weekend
- Creating three-hour sales time buckets
- Creating broader time-period classifications

### Revenue Calculation

```text
Total Amount = Unit Price × Transaction Quantity

