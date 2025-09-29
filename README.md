# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `p1_retail_db`

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
-**This table is temporary and designed to accept all data as flexible text (VARCHAR), preventing MySQL's strict data validation rules from rejecting any rows.

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
-**Execute your file loading command into the flexible staging table. Since all target columns are text, all 2000 rows will load successfully.

### 4. Create the Final Production Table (retail_sales)
**This is your final destination table with all the correct data types (INT, DATE, FLOAT, etc.).

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

