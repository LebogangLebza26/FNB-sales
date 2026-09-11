-- Databricks notebook source
DESCRIBE TABLE fnbdataset.sales.fnb_sales_2021;

CREATE OR REPLACE TABLE fnbdataset.sales.fnb_sales_2021
AS
  SELECT 
    CAST(Date AS DATE) AS Date,
    CASE DAYOFWEEK(CAST(Date AS DATE))
        WHEN 1 THEN 'Sunday'
        WHEN 2 THEN 'Monday'
        WHEN 3 THEN 'Tuesday'
        WHEN 4 THEN 'Wednesday'
        WHEN 5 THEN 'Thursday'
        WHEN 6 THEN 'Friday'
        WHEN 7 THEN 'Saturday'
    END AS day_name,
    DAYOFWEEK(CAST(Date AS DATE)) AS day_number,
    DATE_FORMAT(CAST(Date AS DATE), 'MMMM') AS month_name,
    MONTH(CAST(Date AS DATE)) AS month_number,
    YEAR(CAST(Date AS DATE)) AS year,
    CASE
        WHEN HOUR(Date) BETWEEN 6 AND 8 THEN '06:00–09:00'
        WHEN HOUR(Date) BETWEEN 9 AND 11 THEN '09:00–12:00'
        WHEN HOUR(Date) BETWEEN 12 AND 14 THEN '12:00–15:00'
        WHEN HOUR(Date) BETWEEN 15 AND 17 THEN '15:00–18:00'
        WHEN HOUR(Date) BETWEEN 18 AND 20 THEN '18:00–21:00'
    END AS time_of_day,
    CASE 
        WHEN HOUR(Date) BETWEEN 7 AND 9 THEN 'Morning'
        WHEN HOUR(Date) BETWEEN 10 AND 12 THEN 'Afternoon'
        WHEN HOUR(Date) BETWEEN 13 AND 15 THEN 'Evening'
        WHEN HOUR(Date) BETWEEN 16 AND 18 THEN 'Night'
        WHEN HOUR(Date) >= 19 AND HOUR(Date) <= 20 THEN 'Closing hours'
        ELSE 'Night'
    END AS Time_bucket,
    Sales,
    Cost_Of_Sales AS Cost_Of_Sales,
    Quantity_Sold AS Quantity_Sold
  FROM fnbdataset.sales.fnb_sales_2021;

SELECT *
FROM fnbdataset.sales.fnb_sales_2021DESCRIBE TABLE fnbdataset.sales.fnb_sales_2021;

CREATE OR REPLACE TABLE fnbdataset.sales.fnb_sales_2021
AS
  SELECT 
    CAST(Date AS DATE) AS Date,
    CASE DAYOFWEEK(CAST(Date AS DATE))
        WHEN 1 THEN 'Sunday'
        WHEN 2 THEN 'Monday'
        WHEN 3 THEN 'Tuesday'
        WHEN 4 THEN 'Wednesday'
        WHEN 5 THEN 'Thursday'
        WHEN 6 THEN 'Friday'
        WHEN 7 THEN 'Saturday'
    END AS day_name,
    DAYOFWEEK(CAST(Date AS DATE)) AS day_number,
    DATE_FORMAT(CAST(Date AS DATE), 'MMMM') AS month_name,
    MONTH(CAST(Date AS DATE)) AS month_number,
    YEAR(CAST(Date AS DATE)) AS year,
    CASE
        WHEN HOUR(Date) BETWEEN 6 AND 8 THEN '06:00–09:00'
        WHEN HOUR(Date) BETWEEN 9 AND 11 THEN '09:00–12:00'
        WHEN HOUR(Date) BETWEEN 12 AND 14 THEN '12:00–15:00'
        WHEN HOUR(Date) BETWEEN 15 AND 17 THEN '15:00–18:00'
        WHEN HOUR(Date) BETWEEN 18 AND 20 THEN '18:00–21:00'
    END AS time_of_day,
    CASE 
        WHEN HOUR(Date) BETWEEN 7 AND 9 THEN 'Morning'
        WHEN HOUR(Date) BETWEEN 10 AND 12 THEN 'Afternoon'
        WHEN HOUR(Date) BETWEEN 13 AND 15 THEN 'Evening'
        WHEN HOUR(Date) BETWEEN 16 AND 18 THEN 'Night'
        WHEN HOUR(Date) >= 19 AND HOUR(Date) <= 20 THEN 'Closing hours'
        ELSE 'Night'
    END AS Time_bucket,
    Sales,
    Cost_Of_Sales AS Cost_Of_Sales,
    Quantity_Sold AS Quantity_Sold
  FROM fnbdataset.sales.fnb_sales_2021;

SELECT *
FROM fnbdataset.sales.fnb_sales_2021