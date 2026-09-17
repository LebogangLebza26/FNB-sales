-- Databricks notebook source
DESCRIBE TABLE fnbdataset.sales.fnb_sales_2021;

CREATE OR REPLACE TABLE fnbdataset.sales.fnb_sales_2021
AS
  SELECT 
    CAST(Day_Of_Week AS Date) AS Day_Of_Week,
    CASE DAYOFWEEK(CAST(Day_Of_Week AS Date))
        WHEN 1 THEN 'Sunday'
        WHEN 2 THEN 'Monday'
        WHEN 3 THEN 'Tuesday'
        WHEN 4 THEN 'Wednesday'
        WHEN 5 THEN 'Thursday'
        WHEN 6 THEN 'Friday'
        WHEN 7 THEN 'Saturday'
    END AS day_name,
    DATE_FORMAT(CAST(Day_Of_Week AS DATE), 'EEEE') AS day_profile,
    DATE_FORMAT(CAST(Day_Of_Week AS DATE), 'MMMM') AS month_name,
    MONTH(CAST(Day_Of_Week AS DATE)) AS month_number,
    YEAR(CAST(Day_Of_Week AS DATE)) AS year,
    CASE
        WHEN HOUR(Day_Of_Week) BETWEEN 6 AND 8 THEN '06:00–09:00' 
        WHEN HOUR(Day_Of_Week) BETWEEN 9 AND 11 THEN '09:00–12:00' 
        WHEN HOUR(Day_Of_Week) BETWEEN 12 AND 14 THEN '12:00–15:00' 
        WHEN HOUR(Day_Of_Week) BETWEEN 15 AND 17 THEN '15:00–18:00' 
        WHEN HOUR(Day_Of_Week) BETWEEN 18 AND 20 THEN '18:00–21:00' 
    END AS time_slots,
    CASE 
        WHEN HOUR(Day_Of_Week) BETWEEN 7 AND 9 THEN 'Morning'
        WHEN HOUR(Day_Of_Week) BETWEEN 10 AND 12 THEN 'Afternoon'
        WHEN HOUR(Day_Of_Week) BETWEEN 13 AND 15 THEN 'Evening'
        WHEN HOUR(Day_Of_Week) BETWEEN 16 AND 18 THEN 'Night'
        WHEN HOUR(Day_Of_Week) >= 19 AND HOUR(Day_Of_Week) <= 20 THEN 'Closing hours'
        ELSE 'Mid_Night'
    END AS time_Bucket,
    Sales,
    Cost_Of_Sales AS Cost_Of_Sales,
    Quantity_Sold AS Quantity_Sold
  FROM fnbdataset.sales.fnb_sales_2021;

SELECT *
FROM fnbdataset.sales.fnb_sales_2021;




