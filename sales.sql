-- SQL RETAIL_SALES_ANALYSIS

create database project;

use project;


select * from sales
limit 10;

alter table sales
rename column ï»¿transactions_id to transaction_id;

select count(*) from sales;

select sale_time from sales;

alter table sales 
modify column sale_time time;

alter table sales 
modify column sale_date date;

-- Data cleaning
select * from sales
where 
     transaction_id is null
     or 
     sale_time is null
     or 
     sale_date is null
     or
     customer_id is null
     or 
     gender is null
     or 
     age is null
     or
     category is null
     or
     quantiy is null
     or 
     price_per_unit is null
     or 
     cogs is null
     or 
     total_sale is null;
-- Data exploration

-- how many sales we have?
select count(*) as total_sales from sales;
-- how many unique customers we have?
select count(distinct customer_id) as customers from sales;

select distinct category from  sales;

-- Data analysis & Business key  problems & answers

-- My analysis and finding
-- 1. write a quary to retrieve all columns for sales made on '2022-11-05
select * from sales
where sale_date='2022-11-05';
-- 2. write a quary to retrieve all transactions where the category is 'clothing' and the 
-- quantity sold in the month of Nov-2022?
select *
from sales
where category='clothing'
and date_format(sale_date,'%Y-%m')='2022-11'
and quantiy>=4;

-- 3. write a quary to calculate the total sales(total_sale) for each category?
select category,
sum(total_sale)
from sales
group by category;
-- 4. write a quary to find average age of customers who purchased items from the 'beauty' category?
select avg(age)
from sales
where category='beauty';

-- 5. write a quary to find all transactions where the total_sale is greater than 1000?
select * from sales
where total_sale>1000;

-- 6. write a query to find the number of transactions (transactions_id) made by each gender in each category? 
select count(transaction_id) ,gender,category
from sales
group by gender,category
order by 1; 

-- 7. write a sql query to calculate the average sale for each month.find the first selling month in each year ?
select extract(year from sale_date),extract(month  from sale_date),
avg(total_sale) as total_sales,
rank()over(partition by extract(year from sale_date) order by avg(total_sale))as rn
from sales
group by 1,2;
-- 8.write a query to find top 5 customers based on the highest total sales?
select customer_id,
sum(total_sale)
from sales
group by 1
order by 2 desc
limit 5;
-- 9. write a query to find the number of unique customers who purchased items from each category?
select category,
count(distinct(customer_id))
from sales
group by category;
-- 10. write a query to create each shift and number of orders(exampple morning<=12,afternoon between 12&17,evening>17)?
with  hour_style as(
select *,
case 
when extract(hour from sale_time)<=12 then 'morning'
when extract(hour from sale_time) between 12 and 17 then 'afternoon'
else 'eveniing'
end as shifts
from sales)
select shifts,
count(*)  as total_orders
from hour_style
group by shifts;

-- End of project
