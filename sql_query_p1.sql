-- Set Up the Database
CREATE DATABASE Sql_project_p1;

-- Create the Staging Table
DROP TABLE IF EXISTS retail_sales_staging;
CREATE TABLE retail_sales_staging (
    transactions_id VARCHAR(50) PRIMARY KEY,
    sale_date VARCHAR(50),
    sale_time VARCHAR(50),
    customer_id VARCHAR(50),
    gender VARCHAR(50),
    age VARCHAR(50),
    category VARCHAR(50),
    quantity VARCHAR(50),
    price_per_unit VARCHAR(50),
    cogs VARCHAR(50),
    total_sale VARCHAR(50)
);

-- Create the Final Production Table
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales (
    transactions_id INT PRIMARY KEY,
    sale_date DATE NULL,
    sale_time TIME NULL,
    customer_id INT NULL,
    gender VARCHAR(15) NULL,
    age INT NULL,
    category VARCHAR(20) NULL,
    quantity INT NULL,
    price_per_unit FLOAT NULL,
    cogs FLOAT NULL,
    total_sale FLOAT
);

-- Transform and Insert Data (Clean the Blanks)
INSERT INTO retail_sales
SELECT
    CAST(NULLIF(transactions_id, '') AS SIGNED) AS transactions_id,
    NULLIF(sale_date, ''),
    NULLIF(sale_time, ''),
    CAST(NULLIF(customer_id, '') AS SIGNED) AS customer_id,
    NULLIF(gender, ''),
    CAST(NULLIF(age, '') AS SIGNED) AS age,
    NULLIF(category, ''),
    CAST(NULLIF(quantity, '') AS SIGNED) AS quantity,
    CAST(NULLIF(price_per_unit, '') AS DECIMAL(10, 2)) AS price_per_unit,
    CAST(NULLIF(cogs, '') AS DECIMAL(10, 2)) AS cogs,
    CAST(NULLIF(total_sale, '') AS DECIMAL(10, 2)) AS total_sale
FROM
    retail_sales_staging;

--  Final Verification
SELECT 
    COUNT(*)
FROM
    retail_sales;-- should show 2000
SELECT 
    COUNT(*)
FROM
    retail_sales
WHERE
    age IS NULL;-- Should show 10 (the number of rows missing age)

-- Data Cleaning
SELECT 
    *
FROM
    retail_sales
WHERE
    transactions_id IS NULL
        OR sale_date IS NULL
        OR sale_time IS NULL
        OR gender IS NULL
        OR category IS NULL
        OR quantity IS NULL
        OR cogs IS NULL
        OR total_sale IS NULL;
    
DELETE FROM retail_sales 
WHERE
    transactions_id IS NULL
    OR sale_date IS NULL
    OR sale_time IS NULL
    OR gender IS NULL
    OR category IS NULL
    OR quantity IS NULL
    OR cogs IS NULL
    OR total_sale IS NULL;

-- Data Exploration
-- How many sales we have 
SELECT 
    COUNT(*) AS total_sales
FROM
    retail_sales;

-- How many uniuque customers we have ?
SELECT 
    COUNT(DISTINCT (customer_id))
FROM
    retail_sales;
SELECT DISTINCT
    category
FROM
    retail_sales;

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
SELECT 
    *
FROM
    retail_sales
WHERE
    sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
SELECT 
    *
FROM
    retail_sales
WHERE
    category = 'Clothing' AND quantity >= 4
        AND sale_date >= '2022-11-01'
        AND sale_date < '2022-12-01';

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT 
    category,
    SUM(total_sale) AS total_sale,
    COUNT(*) AS total_orders
FROM
    retail_sales
GROUP BY category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT 
    ROUND(AVG(age), 2) AS avg_age
FROM
    retail_sales
WHERE
    category = 'Beauty';
 
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT 
    *
FROM
    retail_sales
WHERE
    total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT 
    category, gender, COUNT(*) AS total_trans
FROM
    retail_sales
GROUP BY category , gender
ORDER BY category;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT 
	year,
    month,
    avg_sales 
FROM(
	SELECT 
		EXTRACT(YEAR FROM sale_date) AS Year,
		EXTRACT(MONTH FROM sale_date) AS month,
		ROUND(AVG(total_sale),2) AS avg_sales,
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY ROUND(AVG(total_sale),2) DESC) AS r
FROM retail_sales
GROUP BY  1,2
) AS t1
WHERE r=1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT 
    customer_id, SUM(total_sale) AS total_sale
FROM
    retail_sales
GROUP BY customer_id
ORDER BY total_sale DESC
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT 
    category, COUNT(DISTINCT customer_id) AS dist_cust
FROM
    retail_sales
GROUP BY category;    

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sale
AS
(
SELECT *,
	CASE 
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
        END AS shift
FROM retail_sales
)
SELECT 
		shift,
        COUNT(*) AS total_sale
FROM hourly_sale
GROUP BY shift;	
		