# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `Sql_project_p1`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `Sql_project_p1`.
  
  ```sql
  CREATE DATABASE Sql_project_p1;
  USE Sql_project_p1;

### 2.  Create the Staging Table (retail_sales_staging)
- **Table Creation**: This table is temporary and designed to accept all data as flexible text (VARCHAR), preventing MySQL's strict data validation rules from rejecting any rows.

```sql
  DROP TABLE IF EXISTS retail_sales_staging;
  CREATE TABLE retail_sales_staging
  (
    transactions_id VARCHAR(50) PRIMARY KEY,
    sale_date       VARCHAR(50),
    sale_time       VARCHAR(50),
    customer_id     VARCHAR(50),
    gender          VARCHAR(50),
    age             VARCHAR(50),
    category        VARCHAR(50),
    quantity        VARCHAR(50),
    price_per_unit  VARCHAR(50),
    cogs            VARCHAR(50),
    total_sale      VARCHAR(50)
  );
```

### 3. Load All Data into the Staging Table
**Load Data** : Execute your file loading command into the flexible staging table. Since all target columns are text, all 2000 rows will load successfully.

### 4. Create the Final Production Table (retail_sales)
 **Final Table** : This is your final destination table with all the correct data types (INT, DATE, FLOAT, etc.).

```sql
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date       DATE NULL,
    sale_time       TIME NULL,
    customer_id     INT NULL,
    gender          VARCHAR(15) NULL,
    age             INT NULL,
    category        VARCHAR(20) NULL,
    quantity        INT NULL,
    price_per_unit  FLOAT NULL,
    cogs            FLOAT NULL,
    total_sale      FLOAT
);
```

### 5. Transform and Insert Data (Clean the Blanks)
This is the most important step. It moves the data from the staging table to the final table while simultaneously performing two crucial operations:

**Cleaning the Blanks**: NULLIF(column_name, '') converts all empty strings ('') into true SQL NULL values.
**Casting Data Types**: CAST( ... AS [TYPE]) ensures that the text data is converted to the correct numeric format (SIGNED for integers, DECIMAL for floats).

```sql
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
```

### 6. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
```sql
SELECT 
  *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantity >= 4
```

3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty'
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
SELECT * FROM retail_sales
WHERE total_sale > 1000
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
SELECT 
    category,
    gender,
    COUNT(*) as total_trans
FROM retail_sales
GROUP 
    BY 
    category,
    gender
ORDER BY 1
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
SELECT 
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1, 2
) as t1
WHERE rank = 1
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
```sql
SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.
