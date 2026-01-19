CREATE DATABASE retail_db;
USE retail_db;

CREATE TABLE retail_sales (
    transaction_id BIGINT,
    date DATE,
    customer_id VARCHAR(50),
    gender VARCHAR(10),
    age INT,
    product_category VARCHAR(100),
    quantity INT,
    price_per_unit DECIMAL(10,2),
    total_amount DECIMAL(12,2)
);

SELECT COUNT(*) FROM retail_sales_dataset;
SELECT * FROM retail_sales_dataset LIMIT 10;

SET SQL_SAFE_UPDATES = 0;

UPDATE retail_sales_dataset
SET age = (
    SELECT avg_age FROM (
        SELECT ROUND(AVG(age)) AS avg_age 
        FROM retail_sales_dataset
    ) AS temp
)
WHERE age IS NULL;

SELECT COUNT(*) AS null_ages
FROM retail_sales_dataset
WHERE age IS NULL;

SELECT SUM(`Total Amount`) AS total_sales
FROM retail_sales_dataset;

SELECT `Product Category`, SUM(`Total Amount`) AS sales
FROM retail_sales_dataset
GROUP BY `Product Category`
ORDER BY sales DESC;

SELECT DATE_FORMAT(`Date`,'%Y-%m') AS month,
       SUM(`Total Amount`) AS sales
FROM retail_sales_dataset
GROUP BY month
ORDER BY month;

SELECT `Customer ID`, SUM(`Total Amount`) AS total_spent
FROM retail_sales_dataset
GROUP BY `Customer ID`
ORDER BY total_spent DESC
LIMIT 10;

SELECT `Customer ID`, SUM(`Total Amount`) AS total_spent,
CASE
 WHEN SUM(`Total Amount`) > 50000 THEN 'High Value'
 WHEN SUM(`Total Amount`) BETWEEN 20000 AND 50000 THEN 'Medium Value'
 ELSE 'Low Value'
END AS segment
FROM retail_sales_dataset
GROUP BY `Customer ID`;

SELECT `Product Category`,
       SUM(`Total Amount`) AS sales,
       SUM(`Total Amount`)*0.30 AS estimated_profit
FROM retail_sales_dataset
GROUP BY `Product Category`;

CREATE OR REPLACE VIEW monthly_sales AS
SELECT DATE_FORMAT(`Date`,'%Y-%m') AS month,
       SUM(`Total Amount`) AS sales
FROM retail_sales_dataset
GROUP BY month;

DROP PROCEDURE IF EXISTS GetCategorySales;

DROP PROCEDURE IF EXISTS GetCategorySales;

DELIMITER $$

CREATE PROCEDURE GetCategorySales(IN cat VARCHAR(100))
BEGIN
    SELECT 
        `Product Category`,
        SUM(`Total Amount`) AS sales
    FROM retail_sales_dataset
    WHERE `Product Category` = cat
    GROUP BY `Product Category`;
END$$

DELIMITER ;

CALL GetCategorySales('Electronics');

SELECT 
    `Product Category`,
    SUM(`Total Amount`) AS total_sales
FROM retail_sales_dataset
GROUP BY `Product Category`
ORDER BY total_sales DESC;






















