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

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------- GENERAL QUESTION--------------------------------------------------------
 /**How many unique cities does the data have?**/
 SELECT DISTINCT city FROM sales;
 /**In which city is each branch**/
SELECT DISTINCT city, branch FROM sales;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------- PRODUCT QUESTION ANALYSIS-----------------------------------------
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
SELECT product_line, ROUND(AVG(rating),2) AS average_rating FROM sales GROUP BY product_line
ORDER BY average_rating DESC;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------- SALES QUESTION ANALYSIS --------------------------------------
/**Number of sales made in each time of the day per weekday?**/
SELECT dayname, time_of_day, COUNT(invoice_id) AS total_sales
FROM sales GROUP BY dayname, time_of_day HAVING dayname NOT IN ('Sunday','Saturday') 
ORDER BY total_sales DESC;
/**Identify the customer type that generates the highest revenue.**/
SELECT customer_type, SUM(total) AS total_rev FROM sales GROUP BY customer_type ORDER BY total_rev DESC LIMIT 1;
/**Which city has the largest tax percent/ VAT (Value Added Tax)?**/
SELECT city, ROUND(SUM(tax_pct), 2) AS total_tax_pct FROM sales GROUP BY city ORDER BY total_tax_pct DESC LIMIT 1;
/**Which customer type pays the most VAT?**/
SELECT customer_type, ROUND(SUM(tax_pct),2) AS total_VAT FROM sales GROUP BY customer_type ORDER BY total_VAT
DESC LIMIT 1;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------- CUSTOMER QUESTION ANALYSIS --------------------------------------
/**How many unique customer types does the data have**/
SELECT DISTINCT customer_type FROM sales;
/**How many unique payment methods does the data have?**/
SELECT DISTINCT payment FROM sales;
/**Which is the most common customer type?**/
SELECT customer_type, COUNT(customer_type) AS cnt FROM sales GROUP BY customer_type ORDER BY cnt DESC LIMIT 1;
/**Which customer type buys the most?**/
SELECT customer_type, count(*) AS cnt FROM sales GROUP BY customer_type;
/**What is the gender of most of the customers?**/
SELECT gender, COUNT(gender) AS gender_cnt FROM sales GROUP BY gender;
/**What is the gender distribution per branch?**/
SELECT branch,
    SUM(CASE WHEN Gender = 'Male' THEN 1 ELSE 0 END) AS male_count,
    SUM(CASE WHEN Gender = 'Female' THEN 1 ELSE 0 END) AS female_count
FROM sales GROUP BY branch;
/**Which time of the day do customers give most ratings?**/
SELECT SUM(rating) AS sum_of_rating , time_of_day FROM sales GROUP BY time_of_day ORDER BY sum_of_rating DESC;
/**Which time of the day do customers give most ratings per branch?**/
SELECT branch, time_of_day, COUNT(rating) AS rating_count FROM sales GROUP BY branch, time_of_day
ORDER BY Branch, rating_count DESC;
/**Which day of the week has the best avg ratings?**/
SELECT dayname, ROUND(AVG(rating),2) AS avg_rating FROM sales GROUP BY dayname ORDER BY avg_rating DESC LIMIT 1;
/**Which day of the week has the best average ratings per branch?**/
SELECT branch, dayname, ROUND(AVG(rating),2) AS avg_rating FROM sales GROUP BY branch, dayname 
ORDER BY branch, avg_rating DESC;
/**---------------------------------------------E N D---------------------------------------------------**/
