-- Databricks notebook source
--Checking datase
SELECT 
* FROM `fnbdataset`.`sales`.`FNB_sales_2021`;

----------------------------------------------------------
--Structure of dataset
DESCRIBE fnbdataset.sales.fnb_sales_2021;

-----------------------------------------------------------
--Chcking duplicates in datasets for all columns
SELECT COUNT (*) AS dup_cnt
FROM fnbdataset.sales.fnb_sales_2021
GROUP BY ALL
HAVING COUNT(*)>1;

---------------------------------------------------------
--Daily price per unit
SELECT
    date,
    Sales,
    `Quantity Sold`,
    ROUND(Sales / `Quantity Sold`, 4) AS price_per_unit
FROM fnbdataset.sales.fnb_sales_2021
ORDER BY date;

-----------------------------------------------------
--Average unit sales price
SELECT
    ROUND(AVG(`Cost Of Sales`), 4)                   AS avg_price_simple,
    ROUND(SUM(Sales) * 1.0 / SUM(`Quantity Sold`), 4) AS avg_price_volume_weighted
FROM fnbdataset.sales.fnb_sales_2021;

----------------------------------------------------------
--Daily % gross profit
SELECT
    Date,
    ROUND((Sales - `Cost Of Sales`) / sales * 100, 4) AS gross_profit_pct
FROM fnbdataset.sales.fnb_sales_2021;

------------------------------------------------------------------
--Daily % gross profit per unit
SELECT
    Date,
   Sales,
    `Cost Of Sales`,
    ROUND((Sales - `Cost Of Sales`) / Sales * 100, 4) AS gross_profit_pct_per_unit
FROM fnbdataset.sales.fnb_sales_2021;

----------------------------------------------------------------
--Promo period
SELECT
    Date,
    ROUND(AVG(`Cost Of Sales`) OVER (
        ORDER BY Date
        ROWS BETWEEN 15 PRECEDING AND 15 FOLLOWING
    ), 2) AS rolling_avg_price
FROM fnbdataset.sales.fnb_sales_2021;

-------------------------------------------------------------
--Labelling promo perods and baseline periods
CREATE OR REPLACE VIEW v_promo_periods AS
SELECT Date,`Cost Of Sales`, `Quantity Sold`,
    CASE
        WHEN Date BETWEEN '2015-09-24' AND '2015-10-06' THEN 'Promo 1'
        WHEN Date BETWEEN '2016-01-29' AND '2016-02-01' THEN 'Promo 2'
        WHEN Date BETWEEN '2016-06-30' AND '2016-07-06' THEN 'Promo 3'
        WHEN Date BETWEEN '2015-08-25' AND '2015-09-23' THEN 'Baseline 1'
        WHEN Date BETWEEN '2015-12-30' AND '2016-01-28' THEN 'Baseline 2'
        WHEN Date BETWEEN '2016-05-31' AND '2016-06-29' THEN 'Baseline 3'
        ELSE NULL
    END AS period_label
FROM fnbdataset.sales.fnb_sales_2021;

-----------------------------------------------------------------
--Price Elasticity of Demand
WITH v_period_summary AS (
    SELECT
        period_label,
        CASE WHEN period_label LIKE 'Promo%' THEN 'Promo' ELSE 'Baseline' END AS period_type,
        SUBSTR(period_label, -1) AS promo_group,
        ROUND(AVG(`Cost Of Sales`), 4) AS avg_price,
        ROUND(AVG(`Quantity Sold`), 1) AS avg_qty
    FROM v_promo_periods
    WHERE period_label IS NOT NULL
    GROUP BY period_label
)
SELECT
    b.promo_group,
    b.avg_price AS baseline_price,
    p.avg_price AS promo_price,
    ROUND((p.avg_price - b.avg_price) / b.avg_price * 100, 2) AS pct_change_price,
    b.avg_qty AS baseline_qty,
    p.avg_qty AS promo_qty,
    ROUND((p.avg_qty - b.avg_qty) / b.avg_qty * 100, 2) AS pct_change_qty,
    ROUND(
        ((p.avg_qty - b.avg_qty) / b.avg_qty) / ((p.avg_price - b.avg_price) / b.avg_price),
        3
    ) AS price_elasticity_of_demand
FROM v_period_summary b
JOIN v_period_summary p
  ON b.promo_group = p.promo_group
 AND b.period_type = 'Baseline'
 AND p.period_type = 'Promo';

----------------------------------------------------------------------
--Does it perform better on promo?
SELECT
    p.period_label,
    CASE WHEN p.period_label LIKE 'Promo%' THEN 'Promo' ELSE 'Baseline' END AS period_type,
    ROUND(AVG(t.Sales), 2) AS avg_daily_sales_rand,
    ROUND(AVG(t.Sales - t.`Cost Of Sales`), 2) AS avg_daily_gross_profit_rand,
    ROUND(AVG((t.Sales - t.`Cost Of Sales`) / t.Sales * 100), 2) AS avg_gross_profit_pct
FROM v_promo_periods p
JOIN fnbdataset.sales.fnb_sales_2021 t ON t.Date = p.Date
WHERE p.period_label IS NOT NULL
GROUP BY p.period_label;

-------------------------------------------------------------------------------

-- Monthly trend
SELECT
    DATE_FORMAT(Date, 'yyyy-MM') AS year_month,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(AVG((Sales - `Cost Of Sales`) / Sales * 100), 2) AS avg_gross_profit_pct
FROM fnbdataset.sales.fnb_sales_2021
GROUP BY DATE_FORMAT(Date, 'yyyy-MM')
ORDER BY year_month;


-- Day-of-week pattern
SELECT
    DAYOFWEEK(Date) AS day_of_week,
    ROUND(AVG(Sales), 2) AS avg_daily_sales
FROM fnbdataset.sales.fnb_sales_2021
GROUP BY DAYOFWEEK(Date)
ORDER BY day_of_week;--Checking datase
SELECT 
* FROM `fnbdataset`.`sales`.`FNB_sales_2021`;

----------------------------------------------------------
--Structure of dataset
DESCRIBE fnbdataset.sales.fnb_sales_2021;

-----------------------------------------------------------
--Chcking duplicates in datasets for all columns
SELECT COUNT (*) AS dup_cnt
FROM fnbdataset.sales.fnb_sales_2021
GROUP BY ALL
HAVING COUNT(*)>1;

---------------------------------------------------------
--Daily price per unit
SELECT
    date,
    Sales,
    `Quantity Sold`,
    ROUND(Sales / `Quantity Sold`, 4) AS price_per_unit
FROM fnbdataset.sales.fnb_sales_2021
ORDER BY date;

-----------------------------------------------------
--Average unit sales price
SELECT
    ROUND(AVG(`Cost Of Sales`), 4)                   AS avg_price_simple,
    ROUND(SUM(Sales) * 1.0 / SUM(`Quantity Sold`), 4) AS avg_price_volume_weighted
FROM fnbdataset.sales.fnb_sales_2021;

----------------------------------------------------------
--Daily % gross profit
SELECT
    Date,
    ROUND((Sales - `Cost Of Sales`) / sales * 100, 4) AS gross_profit_pct
FROM fnbdataset.sales.fnb_sales_2021;

------------------------------------------------------------------
--Daily % gross profit per unit
SELECT
    Date,
   Sales,
    `Cost Of Sales`,
    ROUND((Sales - `Cost Of Sales`) / Sales * 100, 4) AS gross_profit_pct_per_unit
FROM fnbdataset.sales.fnb_sales_2021;

----------------------------------------------------------------
--Promo period
SELECT
    Date,
    ROUND(AVG(`Cost Of Sales`) OVER (
        ORDER BY Date
        ROWS BETWEEN 15 PRECEDING AND 15 FOLLOWING
    ), 2) AS rolling_avg_price
FROM fnbdataset.sales.fnb_sales_2021;

-------------------------------------------------------------
--Labelling promo perods and baseline periods
CREATE OR REPLACE VIEW v_promo_periods AS
SELECT Date,`Cost Of Sales`, `Quantity Sold`,
    CASE
        WHEN Date BETWEEN '2015-09-24' AND '2015-10-06' THEN 'Promo 1'
        WHEN Date BETWEEN '2016-01-29' AND '2016-02-01' THEN 'Promo 2'
        WHEN Date BETWEEN '2016-06-30' AND '2016-07-06' THEN 'Promo 3'
        WHEN Date BETWEEN '2015-08-25' AND '2015-09-23' THEN 'Baseline 1'
        WHEN Date BETWEEN '2015-12-30' AND '2016-01-28' THEN 'Baseline 2'
        WHEN Date BETWEEN '2016-05-31' AND '2016-06-29' THEN 'Baseline 3'
        ELSE NULL
    END AS period_label
FROM fnbdataset.sales.fnb_sales_2021;

-----------------------------------------------------------------
--Price Elasticity of Demand
WITH v_period_summary AS (
    SELECT
        period_label,
        CASE WHEN period_label LIKE 'Promo%' THEN 'Promo' ELSE 'Baseline' END AS period_type,
        SUBSTR(period_label, -1) AS promo_group,
        ROUND(AVG(`Cost Of Sales`), 4) AS avg_price,
        ROUND(AVG(`Quantity Sold`), 1) AS avg_qty
    FROM v_promo_periods
    WHERE period_label IS NOT NULL
    GROUP BY period_label
)
SELECT
    b.promo_group,
    b.avg_price AS baseline_price,
    p.avg_price AS promo_price,
    ROUND((p.avg_price - b.avg_price) / b.avg_price * 100, 2) AS pct_change_price,
    b.avg_qty AS baseline_qty,
    p.avg_qty AS promo_qty,
    ROUND((p.avg_qty - b.avg_qty) / b.avg_qty * 100, 2) AS pct_change_qty,
    ROUND(
        ((p.avg_qty - b.avg_qty) / b.avg_qty) / ((p.avg_price - b.avg_price) / b.avg_price),
        3
    ) AS price_elasticity_of_demand
FROM v_period_summary b
JOIN v_period_summary p
  ON b.promo_group = p.promo_group
 AND b.period_type = 'Baseline'
 AND p.period_type = 'Promo';

----------------------------------------------------------------------
--Does it perform better on promo?
SELECT
    p.period_label,
    CASE WHEN p.period_label LIKE 'Promo%' THEN 'Promo' ELSE 'Baseline' END AS period_type,
    ROUND(AVG(t.Sales), 2) AS avg_daily_sales_rand,
    ROUND(AVG(t.Sales - t.`Cost Of Sales`), 2) AS avg_daily_gross_profit_rand,
    ROUND(AVG((t.Sales - t.`Cost Of Sales`) / t.Sales * 100), 2) AS avg_gross_profit_pct
FROM v_promo_periods p
JOIN fnbdataset.sales.fnb_sales_2021 t ON t.Date = p.Date
WHERE p.period_label IS NOT NULL
GROUP BY p.period_label;

-------------------------------------------------------------------------------

-- Monthly trend
SELECT
    DATE_FORMAT(Date, 'yyyy-MM') AS year_month,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(AVG((Sales - `Cost Of Sales`) / Sales * 100), 2) AS avg_gross_profit_pct
FROM fnbdataset.sales.fnb_sales_2021
GROUP BY DATE_FORMAT(Date, 'yyyy-MM')
ORDER BY year_month;


-- Day-of-week pattern
SELECT
    DAYOFWEEK(Date) AS day_of_week,
    ROUND(AVG(Sales), 2) AS avg_daily_sales
FROM fnbdataset.sales.fnb_sales_2021
GROUP BY DAYOFWEEK(Date)
ORDER BY day_of_week;