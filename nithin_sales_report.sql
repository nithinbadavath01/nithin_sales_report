CREATE DATABASE IF NOT EXISTS sales_analysis;
USE sales_analysis;

-- 1. Drop and create table
DROP TABLE IF EXISTS nithin_sales_report;

CREATE TABLE IF NOT EXISTS nithin_sales_report (
    `Row ID` INT,
    `Order ID` VARCHAR(255),
    `Order Date` DATE,
    `Ship Date` DATE,
    `Ship Mode` VARCHAR(255),
    `Customer ID` VARCHAR(255),
    `Customer Name` VARCHAR(255),
    `Segment` VARCHAR(255),
    `Country/Region` VARCHAR(255),
    `City` VARCHAR(255),
    `State` VARCHAR(255),
    `Postal Code` VARCHAR(255),
    `Region` VARCHAR(255),
    `Product ID` VARCHAR(255),
    `Category` VARCHAR(255),
    `Sub-Category` VARCHAR(255),
    `Product Name` TEXT,
    `Sales` DECIMAL(10,2),
    `Quantity` INT,
    `Discount` DECIMAL(5,2),
    `Profit` DECIMAL(10,2)
);

select * from nithin_sales_report;




-- 3. Clean invalid rows
SET SQL_SAFE_UPDATES = 0;
DELETE FROM nithin_sales_report
WHERE sales IS NULL OR sales < 0
    OR profit IS NULL
    OR quantity IS NULL OR quantity <= 0;
SET SQL_SAFE_UPDATES = 1; -- (Optionally re-enable)


-- 4. Profitability by category
SELECT category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    ROUND((SUM(profit)/SUM(sales))*100,2) AS profit_margin_pct
FROM nithin_sales_report
GROUP BY category
ORDER BY profit_margin_pct DESC;

-- 5. Profitability by sub-category
SELECT category, `Sub-Category`,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    ROUND((SUM(profit)/SUM(sales))*100,2) AS profit_margin_pct
FROM nithin_sales_report
GROUP BY category, `Sub-Category`
ORDER BY profit_margin_pct ASC;

-- 6. Seasonal trend (monthly)
SELECT category,
    EXTRACT(YEAR FROM `Order Date`) AS year,
    EXTRACT(MONTH FROM `Order Date`) AS month,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM nithin_sales_report
GROUP BY category, year, month
ORDER BY year, month;

-- 7. Loss-making products
SELECT `Product Name`, category, `Sub-Category`,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM nithin_sales_report
GROUP BY `Product Name`, category, `Sub-Category`
HAVING SUM(profit) < 0
ORDER BY total_profit ASC;

-- 8. Slow-moving products
SELECT `Product Name`, category,
    SUM(quantity) AS total_qty,
    SUM(sales) AS total_sales
FROM nithin_sales_report
GROUP BY `Product Name`, category
ORDER BY total_qty ASC, total_sales ASC;
