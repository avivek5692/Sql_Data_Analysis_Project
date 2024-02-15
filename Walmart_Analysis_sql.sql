show databases;
create database if not exists walmartSales_data  ;

-- Create table
CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
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
    rating FLOAT(2, 1)
);

use walmartsales_data;
select time from sales ;
--------------------------------------------------------------------------------
#Feature Engineering 

select * ,
(
case 
when 'time' between  '00:00:00' and '12:00:00' then 'Morning'
when 'time' between '12:00:01' and '16:00:00' then 'Afternoon'
else 'Evening'
end 
)  as time_of_day
from sales ;

-- Add the time_of_day column
ALter table sales add column time_of_day varchar(20);

update sales 
set time_of_day = (
case 
when 'time' between  '00:00:00' and '12:00:00' then 'Morning'
when 'time' between '12:00:01' and '16:00:00' then 'Afternoon'
else 'Evening'
end 
);

select date , dayname(date) from sales limit 10;
-- Add column day_name 
Alter table sales add column day_name varchar(12);

update sales 
set day_name = dayname(date); 

-- Add month_name 
select date , monthname(date) from sales limit 10 ;

alter table sales add column month_name  varchar(10);

update sales 
set month_name = monthname(date);

-- Generic Questions
-- How many unique cities does the data have ?
 select distinct city from sales ;
 
 -- In which city is each branch ?
 select branch , city from sales 
 group by 1,2;
 
 SELECT 
	city,
    branch
FROM sales;

-- product 
-- 1. How many unique product lines does the data have?
select distinct product_line from sales ;

-- 2. What is the most common payment method?
select payment , count(*) as Count  
  from sales 
  group by 1
  order by 1 desc; 
  
  -- 3. What is the most selling product line?
  select product_line , count(*) as Count
  from sales 
  group by 1 
  order by 2 desc ;
  
  select * from sales limit 5 ;
  -- 4. What is the total revenue by month?
  select month_name , sum(total) from sales 
  group by 1 
  order by 2 desc ;
  
  -- 5. What month had the largest COGS?
select month_name , sum(COGS) as Largest_cogs
from sales 
group by 1 
order by 2 desc limit 1 ;
  
-- 6. What product line had the largest revenue?
select product_line , sum(total) as Total_Revenue 
from sales 
group by 1 
order by 2 desc limit 1 ;

-- 7. What is the city with the largest revenue?
select city  , sum(total) as Total_Revenue 
from sales 
group by 1 
order by 2 desc limit 1 ;

-- 8. What product line had the largest VAT?
select product_line , sum(tax_pct) as Largest_Vat
from sales 
group by 1 
order by 2 desc limit 1 ;

-- 9. Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales

select product_line ,
(
case 
	when sum(quantity) > avg(quantity) then 'Good'
    else 'Bad'
    end
) as product_Nature
from sales 
group by 1 ;

-- 10. Which branch sold more products than average product sold?
select  branch , sum(quantity) from sales 
group by 1 
having sum(quantity) > avg(quantity);

-- 11. What is the most common product line by gender?
select product_line , gender , count(gender) as Tota_cnt 
from sales 
group by 1, 2
order by 3 desc; 

-- 12. What is the average rating of each product line?
SELECT 
    product_line, AVG(rating)
FROM
    sales
GROUP BY 1;

select * from sales limit 5 ;
-----------------------------------------------------------------------------------------
----------------------------------- Sales ----------------------------------------------

-- 1. Number of sales made in each time of the day per weekday
select time_of_day , count(*) as Count_sales 
from sales 
where day_name = 'Sunday'
group by 1 
order by 2 desc ;

-- 2. Which of the customer types brings the most revenue?
select customer_type , sum(total) as Revenue  from sales
group by 1 
order by 2 desc ; 

-- 3. Which city has the largest tax percent/ VAT (Value Added Tax)?
select city , round(sum(tax_pct) , 2) as Largest_tax
from sales 
group by 1 
order by 2 desc limit 1 ;

-- 4. Which customer type pays the most in VAT?
select customer_type , sum(tax_pct) 
from sales 
group by 1
order by 2 desc limit 1;
-------------------------------------------------------------------------------------
-------------------------------- Customer -------------------------------------------
-- 1. How many unique customer types does the data have?
select distinct customer_type from sales ;

-- 2. How many unique payment methods does the data have?
select distinct payment from sales ;

-- 3. What is the most common customer type?
select customer_type , 
count(*) as largest_count from sales 
group by 1 
order  by 2 ;

-- 4. Which customer type buys the most?
SELECT
	customer_type,
    COUNT(*)
FROM sales
GROUP BY customer_type;

-- 5. What is the gender of most of the customers?
select gender , count(*) as Gender_count
from sales 
group by 1
order by 2 desc ;

-- 6. What is the gender distribution per branch?
select * from sales ;
select gender , branch , count(*) from sales 
group by 1,2 
order by 3 desc ;

-- 7. Which time of the day do customers give most ratings?
select time_of_day , count(rating) 
from sales 
group by 1 
order by 2 ;

-- 8. Which time of the day do customers give most ratings per branch?
select time_of_day , branch , count(rating) 
from sales 
group by 1 , 2
order by 2;

-- 9. Which day of the week has the best avg ratings?
select day_name , avg(rating)  from sales 
group by 1 
order by 2 desc ;

-- 10. Which day of the week has the best average ratings per branch?
select day_name ,branch , avg(rating)  from sales 
group by 1 , 2
order by 3 desc ;


























































