select * from retail_sales
where transactions_id ISNULL OR sale_date ISNULL	OR sale_time IS NULL OR customer_id ISNULL OR 	gender IS NULL OR 
age IS NULL
OR 	category IS NULL OR 	
quantiy	IS NULL OR 
price_per_unit IS NULL OR 	
cogs ISNULL OR 	
total_sale IS NULL ;


DELETE FROM RETAIL_SALES
where transactions_id ISNULL OR sale_date ISNULL	OR sale_time IS NULL OR customer_id ISNULL OR 	gender IS NULL OR 	age IS NULL OR 	category IS NULL OR 	quantiy	IS NULL OR price_per_unit IS NULL OR 	cogs ISNULL OR 	
total_sale IS NULL ;

select COUNT(*) from retail_sales;

--DATA EXPLORATION 
SELECT COUNT(*) TRANSACTION_ID FROM RETAIL_SALES ;

SELECT COUNT(*) SALE_DATA FROM RETAIL_SALES ;

SELECT COUNT(*) SALE_TIME FROM RETAIL_SALES;

SELECT COUNT( DISTINCT CUSTOMER_ID ) FROM RETAIL_SALES;

SELECT COUNT( DISTINCT GENDER ) FROM RETAIL_SALES;

SELECT COUNT( DISTINCT AGE ) FROM RETAIL_SALES;
SELECT DISTINCT CATEGORY  FROM RETAIL_SALES;
SELECT DISTINCT QUANTIY  FROM RETAIL_SALES;
SELECT COUNT( DISTINCT PRICE_PER_UNIT ) FROM RETAIL_SALES;
SELECT COUNT( DISTINCT COGS ) FROM RETAIL_SALES;
SELECT COUNT( DISTINCT TOTAL_SALE) FROM RETAIL_SALES;


-- DATA ANALYSIS--

--Write a SQL query to retrieve all columns for sales made on '2022-11-05:

SELECT * FROM RETAIL_SALES
WHERE SALE_DATE = '2022-11-05';

--Write a SQL query to retrieve all transactions where the category is 'Clothing' and 
--the quantity sold is more than 4 in the month of Nov-2022:

SELECT * FROM RETAIL_SALES
WHERE CATEGORY = 'CLOTHING'
AND TO_CHAR(SALE_DATE ,'YYYY-MM') = '2022-11'
AND QUANTIY >=4

--Write a SQL query to calculate the total sales (total_sale) for each category.:
SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1
--Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:

SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty'

--Write a SQL query to find all transactions where the total_sale is greater than 1000.:

SELECT * FROM retail_sales
WHERE total_sale > 1000

--Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:

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

--Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:

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

--**Write a SQL query to find the top 5 customers based on the highest total sales **:

SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

--Write a SQL query to find the number of unique customers who purchased items from each category.:

SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category

--Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

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
