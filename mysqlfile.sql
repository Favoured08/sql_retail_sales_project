--create database sql_project_1
--create table retail_sales 
--ensuring data imported is accurate and nothing missing
select count(*) from retail_sales
--data cleaning: a. checking to see empty columns
select * from retail_sales 
where transactions_id is null
or sale_date is null
or sale_time is null
or customer_id is null
or gender is null
or category is null
or quantity is null
or price_per_unit is null
or cogs is null
or total_sale is null
--b.deleting
delete from retail_sales 
where transactions_id is null
or sale_date is null
or sale_time is null
or customer_id is null
or gender is null
or category is null
or quantity is null
or price_per_unit is null
or cogs is null
or total_sale is null

--data exploration
--total sales
select count(total_sale) as totalSales from retail_sales
--total number of unique customers
select count(distinct customer_id) as customers from retail_sales
--total number of product categories
select count(distinct category) from retail_sales
--product category names
select distinct category from retail_sales

--data analysis

--retrieve all columns for sales made on 2022-11-05
select * from retail_sales where sale_date = '2022-11-05'

--retrieve all transactions where the category is 'clothing' and quantity sold is more than 10 in the month of nov 2022
select * from retail_sales 
where category = 'Clothing' and quantity >=4 and sale_date between '2022-11-01' and  '2022-11-30'

--calaculate the total sale for each category
select category, sum(total_sale) as TotalSale 
from retail_sales group by category

--find total number of transaction made by each gender in each category
select gender, category, count(transactions_id) as transactions 
from retail_sales group by gender, category

--calculate average sales for each month. find out best selling month in each year
select * from (
	select Extract(Month from sale_date) as month, 
			Extract(Year from sale_date) as year,
			Avg(total_sale) as AverageSales,
			Rank() over(partition by EXTRACT(Year from sale_date) order by avg(total_sale)desc) as rank
			from retail_sales
			group by 2,1
			) as t1
	where rank = 1
		

--find top 5 customers based on highest total sales
select customer_id, sum(total_sale) as TotalSale
from retail_sales
group by customer_id
order by 2 desc
limit 5

--find the number of unique customers who purchased items from each category
select 
   count(distinct customer_id) as No_of_uniqueCustomers,
   category from retail_sales 
   group by category

--write a query to create each shift and number of orders(Example morning<=12,Afternoon between 12&17, evening >17)
With hourly_sale 
as
	(select *,
	  case
	      when Extract(Hour from sale_time) < 12 then 'morning'
		  when Extract(Hour from sale_time) between 12 and 17 then 'afternoon'
		  else 'evening'
		  end as shift
		  from retail_sales)
select shift,
count(*) as total_orders
from hourly_sale
group by shift