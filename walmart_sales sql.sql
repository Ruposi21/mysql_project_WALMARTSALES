create database walmart_sales;
use walmart_sales;
create table sales(invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1));
    
    
    /** ADD TIME OF DAY COLUMN**/
    SELECT time , 
    (CASE  WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) AS time_of_day FROM sales;
    
    ALTER table sales add time_of_day varchar(200);
    UPDATE sales SET time_of_day = (
    CASE WHEN 'time' between "00:00:00" AND "12:00:00" THEN "Morning"
         WHEN 'time' between "12:01:00" AND "16:00:00" THEN "Afternoon"
         ELSE "Evening"
	END);
    
/**ADD DAY NAME COLUMN**/
SELECT date,dayname(date) FROM sales;
ALTER table sales add dayname varchar(200);
UPDATE sales SET dayname=Dayname(date);

/** ADD MONTH NAME COLUMN**/
SELECT date, monthname(date) FROM sales;
ALTER table sales add monthname varchar(200);
UPDATE sales SET monthname=MonthName(date);
-------------------------------------------------------------------------------------------------
------------------- GENERAL QUESTION------------------------
 /**How many unique cities does the data have?**/
 SELECT DISTINCT city FROM sales;
 /**In which city is each branch**/
SELECT DISTINCT city, branch FROM sales;
------------------------- PRODUCT-----------------------------------------
/**How many unique product lines does the data have?**/
SELECT count(distinct product_line) FROM sales;
/**What is the most common payment method?**/
SELECT payment, count(payment) AS frquency_common_method FROM sales GROUP BY payment;  
/**What is the most selling product line?**/
SELECT product_line, COUNT(product_line) FROM sales GROUP BY product_line;
/**What is the total revenue by month?**/
SELECT monthname, SUM(total) AS revenue_generated_month FROM sales GROUP BY monthname 
ORDER BY revenue_generated_month DESC ;
/**Which month recorded the highest Cost of Goods Sold (COGS)?**/
SELECT monthname, SUM(cogs) AS total_cogs FROM sales GROUP BY monthname ORDER BY total_cogs DESC LIMIT 1;
/**Which product line generated the highest revenue?**/
SELECT product_line, SUM(total) AS revenue_generated_product_line FROM sales GROUP BY product_line
ORDER BY revenue_generated_product_line DESC LIMIT 1;
/**Which city has the highest revenue?**/
SELECT city, SUM(total) AS total_revenue FROM sales GROUP BY city ORDER BY total_revenue DESC LIMIT 1;
/**Which product line incurred the highest VAT?**/
SELECT product_line, SUM(tax_pct) as VAT FROM sales GROUP BY product_line ORDER BY VAT DESC LIMIT 1;
/**Retrieve each product line and add a column product_category, indicating 'Good' or 'Bad,
' based on whether its sales are above the average.**/
SELECT product_line,
CASE WHEN total > (SELECT AVG(total) FROM sales) THEN 'Good' ELSE 'Bad' END AS product_category FROM sales;
/**Which branch sold more products than average product sold?**/
SELECT branch, SUM(quantity) AS quantity
FROM sales GROUP BY branch HAVING SUM(quantity) > AVG(quantity) ORDER BY quantity DESC;
SELECT branch, sum(quantity) FROM sales
GROUP BY branch
HAVING sum(quantity) >(select avg(quantity) from sales);
/**What is the most common product line by gender?**/
SELECT gender, product_line,  COUNT(gender) AS total_count FROM sales GROUP BY gender, product_line
ORDER BY total_count DESC LIMIT 1 ;
/**What is the average rating of each product line?**/