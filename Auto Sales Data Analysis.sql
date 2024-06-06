-- 1. Checking Samples of the Data
-- To check the first few rows:

SELECT * FROM [Auto Sales data];

-- 2. Data Characteristics
-- Dimensions of the data:

SELECT
    (SELECT COUNT(*) FROM [Auto Sales data]) AS number_of_rows,
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Auto Sales data') AS number_of_columns;

-- 3. Drop Irrelevant Columns
-- To drop irrelevant columns for analysis:

SELECT QUANTITYORDERED, PRICEEACH, ORDERLINENUMBER, SALES, MSRP, DAYS_SINCE_LASTORDER INTO df_num
FROM [Auto Sales data];

SELECT STATUS, PRODUCTLINE, PRODUCTCODE, CUSTOMERNAME, CITY, POSTALCODE, COUNTRY, DEALSIZE INTO df_cat
FROM [Auto Sales data];

-- 4. Descriptive Summary
-- Descriptive summary of numeric features:
SELECT
  AVG(QUANTITYORDERED) AS mean_quantity_ordered,
  STDEV(QUANTITYORDERED) AS std_quantity_ordered,
  MIN(QUANTITYORDERED) AS min_quantity_ordered,
  MAX(QUANTITYORDERED) AS max_quantity_ordered,
  AVG(PRICEEACH) AS mean_price_each,
  STDEV(PRICEEACH) AS std_price_each,
  MIN(PRICEEACH) AS min_price_each,
  MAX(PRICEEACH) AS max_price_each
FROM [Auto Sales data];

-- Descriptive summary of categorical features:

SELECT STATUS, COUNT(*) AS count, COUNT(DISTINCT STATUS) AS unique_status
FROM [Auto Sales data]
GROUP BY STATUS;

SELECT PRODUCTLINE, COUNT(*) AS count, COUNT(DISTINCT PRODUCTLINE) AS unique_productline
FROM [Auto Sales data]
GROUP BY PRODUCTLINE;

-- 5. Missing Values
-- Check for missing values:

SELECT 
  SUM(CASE WHEN ORDERNUMBER IS NULL THEN 1 ELSE 0 END) AS ORDERNUMBER,
  SUM(CASE WHEN QUANTITYORDERED IS NULL THEN 1 ELSE 0 END) AS QUANTITYORDERED
FROM [Auto Sales data];


-- 6. Duplicate Values
-- Check for duplicate values:

WITH CTE AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY 
            ORDERNUMBER, 
            QUANTITYORDERED, 
            PRICEEACH, 
            ORDERLINENUMBER, 
            SALES, 
            ORDERDATE, 
            DAYS_SINCE_LASTORDER, 
            STATUS, 
            PRODUCTLINE, 
            MSRP, 
            PRODUCTCODE, 
            CUSTOMERNAME, 
            PHONE, 
            ADDRESSLINE1, 
            CITY, 
            POSTALCODE, 
            COUNTRY, 
            CONTACTLASTNAME, 
            CONTACTFIRSTNAME, 
            DEALSIZE
            ORDER BY (SELECT NULL)) AS row_num
    FROM [Auto Sales data]
)
SELECT COUNT(*) AS duplicate_count
FROM CTE
WHERE row_num > 1;


-- 7. Univariate Analysis
-- Distribution of categorical features:

SELECT STATUS, COUNT(*) AS count
FROM [Auto Sales data]
GROUP BY STATUS;

SELECT PRODUCTLINE, COUNT(*) AS count
FROM [Auto Sales data]
GROUP BY PRODUCTLINE;

SELECT DEALSIZE, COUNT(*) AS count
FROM [Auto Sales data]
GROUP BY DEALSIZE;

-- Univariate analysis of numeric features:

SELECT
  QUANTITYORDERED,
  COUNT(*) AS count
FROM [Auto Sales data]
GROUP BY QUANTITYORDERED;

-- 8. Top 10 Analysis
-- Top 10 countries, cities, and customers:

SELECT COUNTRY, COUNT(*) AS count
FROM [Auto Sales data]
GROUP BY COUNTRY
ORDER BY count DESC;

SELECT CITY, COUNT(*) AS count
FROM [Auto Sales data]
GROUP BY CITY
ORDER BY count DESC;

SELECT CUSTOMERNAME, COUNT(*) AS count
FROM [Auto Sales data]
GROUP BY CUSTOMERNAME
ORDER BY count DESC;

-- 9. Bivariate Analysis
-- Correlation analysis (simulated with SQL):

WITH Stats AS (
    SELECT 
        AVG(QUANTITYORDERED) AS avg_quantity,
        AVG(SALES) AS avg_sales,
        AVG(PRICEEACH) AS avg_price,
        STDEV(QUANTITYORDERED) AS stdev_quantity,
        STDEV(SALES) AS stdev_sales,
        STDEV(PRICEEACH) AS stdev_price
    FROM [Auto Sales data]
),
Covariance AS (
    SELECT 
        SUM((QUANTITYORDERED - Stats.avg_quantity) * (SALES - Stats.avg_sales)) / COUNT(*) AS cov_quantity_sales,
        SUM((PRICEEACH - Stats.avg_price) * (SALES - Stats.avg_sales)) / COUNT(*) AS cov_price_sales
    FROM [Auto Sales data], Stats
)
SELECT
    cov_quantity_sales / (stdev_quantity * stdev_sales) AS corr_quantity_sales,
    cov_price_sales / (stdev_price * stdev_sales) AS corr_price_sales
FROM Covariance, Stats;


-- Sales distribution by deal size and product line:

SELECT DEALSIZE, AVG(SALES) AS avg_sales, COUNT(*) AS count_sales
FROM [Auto Sales data]
GROUP BY DEALSIZE;

SELECT PRODUCTLINE, AVG(SALES) AS avg_sales, COUNT(*) AS count_sales
FROM [Auto Sales data]
GROUP BY PRODUCTLINE;

-- 10. Time-based Analysis
-- Sales trend over time by year
SELECT 
    YEAR(ORDERDATE) AS year, 
    SUM(SALES) AS total_sales
FROM [Auto Sales data]
GROUP BY YEAR(ORDERDATE);

-- Sales trend over time by quarter
SELECT 
    DATEPART(QUARTER, ORDERDATE) AS quarter, 
    SUM(SALES) AS total_sales
FROM [Auto Sales data]
GROUP BY DATEPART(QUARTER, ORDERDATE);

-- Sales trend over time by month
SELECT 
    MONTH(ORDERDATE) AS month, 
    SUM(SALES) AS total_sales
FROM [Auto Sales data]
GROUP BY MONTH(ORDERDATE);

-- Sales trend over time by week
SELECT 
    DATEPART(WEEK, ORDERDATE) AS week, 
    SUM(SALES) AS total_sales
FROM [Auto Sales data]
GROUP BY DATEPART(WEEK, ORDERDATE);
