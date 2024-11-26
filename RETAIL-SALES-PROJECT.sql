create DATABASE retail_sales;

-- Create TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
            (
                transaction_id INT PRIMARY KEY,	
                sale_date DATE,	 
                sale_time TIME,	
                customer_id	INT,
                gender	VARCHAR(15),
                age	INT,
                category VARCHAR(15),	
                quantity	INT,
                price_per_unit FLOAT,	
                cogs	FLOAT,
                total_sale FLOAT
            );

SELECT * FROM retail_sales
LIMIT 10;




-- DATA CLEANING-- 
-- CHECKING FOR NULL VALUE --
SELECT * FROM retail_sales WHERE
    transactions_id IS NULL
    or sale_date IS null  or sale_time is null or 	customer_id is null or gender is null  or age is null 
    or category is null or  quantiy is null or price_per_unit is null or cogs is null or total_sale is null;

-- DELETE ROWS WITH NULL VALUE--
delete from retail_sales where 
 transactions_id IS NULL
    or sale_date IS null  or sale_time is null or 	customer_id is null or gender is null  or age is null 
    or category is null or  quantiy is null or price_per_unit is null or cogs is null or total_sale is null;

-- DATA EXPLORATION--

-- HOW MANY SALE WE HAVE--
SELECT 
    sum(total_sale) AS total_sales
FROM
    retail_sales;

-- how many unique customer we have? --
SELECT 
    COUNT(distinct customer_id) AS Total_Customer
FROM
    retail_sales;
   
-- how many category we have ? --   
-- DATA CLEANING-- 
-- CHECKING FOR NULL VALUE --
SELECT * FROM retail_sales WHERE
    transactions_id IS NULL
    or sale_date IS null  or sale_time is null or 	customer_id is null or gender is null  or age is null 
    or category is null or  quantiy is null or price_per_unit is null or cogs is null or total_sale is null;

-- DELETE ROWS WITH NULL VALUE--
delete from retail_sales where 
 transactions_id IS NULL
    or sale_date IS null  or sale_time is null or 	customer_id is null or gender is null  or age is null 
    or category is null or  quantiy is null or price_per_unit is null or cogs is null or total_sale is null;

-- DATA EXPLORATION--

-- HOW MANY SALE WE HAVE--
SELECT 
    sum(total_sale) AS total_sales
FROM
    retail_sales;

-- how many unique customer we have? --
SELECT 
    COUNT(distinct customer_id) AS Total_Customer
FROM
    retail_sales;
   
-- how many category we have ? --   
SELECT 
     distinct category
FROM
    retail_sales;
  
-- BUSINESS KEY PROBLEMS AND ANSWERS -- 

-- Q1 WRITE A SQL QUERY TO RETRIVE ALL COLUMNS FOR SALES MDAE ON '2022-11-05'
SELECT 
    *
FROM
    retail_sales
WHERE
    sale_date = '2022-11-05';
    
-- Q2 write a sql query where retrieve all transactions_id  where the category is ' clothing'
-- and the quantity sold is more than 3  and the month of nov-2022  

SELECT 
  *
FROM
  retail_sales
WHERE
  category = 'Clothing' 
  AND quantiy >=4 
  AND sale_date BETWEEN '2022-11-01' AND '2022-11-30';

-- Q3 write a sql query to calculate total sale  and total order for each category
SELECT 
    category,
    SUM(total_sale) AS net_sale,
    COUNT(*) AS total_order
FROM
    retail_sales
GROUP BY category;

-- Q4 write a sql query to find the avg age of customer who purchased the item from the beauty category

SELECT 
    AVG(age)
FROM
    retail_sales
WHERE
    category = 'beauty';

-- Q5 Write a SQL query to find all transactions where the total_sale is greater than 1000
SELECT 
    *
FROM
    retail_sales
WHERE
    total_sale > 1000;

-- Q6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
SELECT 
    category, gender, COUNT(*) AS total_transaction
FROM
    retail_sales
GROUP BY category , gender
ORDER BY category;

-- Q7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
select * from (
SELECT 
    YEAR(sale_date) AS year,
    MONTH(sale_date) AS month,
    AVG(total_sale) AS avg_sale,
    rank() over (partition by YEAR(sale_date) order by  AVG(total_sale) desc ) as ranking
FROM
    retail_sales
GROUP BY year , month
) as t1
where ranking =1 ;

-- Q8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT 
    customer_id, SUM(total_sale) AS total_sales
FROM
    retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

 
-- Q9 Write a SQL query to find the number of unique customers who purchased items from each category
SELECT 
    COUNT(DISTINCT customer_id) AS total_customer, category
FROM
    retail_sales
GROUP BY category;


-- Q10 Write a SQL query to create each shift and number of orders 
-- (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

with hourly_sale as
(
SELECT *, 
    CASE 
        WHEN sale_time < '12:00:00' THEN 'morning'
        WHEN sale_time BETWEEN '12:00:00' AND '17:00:00' THEN 'afternoon'
        WHEN sale_time > '17:00:00' THEN 'evening'
        ELSE 'no'
    END AS shift
FROM retail_sales 
) 
select shift, count(transactions_id) from hourly_sale 
group by shift
