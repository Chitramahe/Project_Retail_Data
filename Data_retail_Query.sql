create database project

use project


create table Data_retail
(
product_id int primary key,
product_name varchar(30),
category varchar(30),
stock_quantity int,
supplier varchar(30),
discount decimal(7,2),
rating decimal(7,2),
reviews int,
sku varchar(30),
warehouse varchar(30),
return_policy varchar(30),
brand varchar(30),
supplier_contact varchar(20),
placeholder int,
price decimal(7,2)
)     

select * from Data_retail


/*ANALYSIS-1
 Identifies products with prices higher than the average price within their category.*/

/* SOLUTION */

with cte as 
(select category,avg(price) as avg_price from Data_retail
group by category)

select dr.product_name,dr.category,dr.price from Data_retail dr
inner join cte
on dr.category = cte.category
where dr.price > cte.avg_price
order by category


/*ANALYSIS-2
 Finding Categories with Highest Average Rating Across Products.*/

/* SOLUTION */

SELECT * FROM 
(
 SELECT product_name,category,avg(rating) as avg_rating, row_number() OVER (PARTITION BY  product_name order by avg(rating) desc) AS row_number 
 FROM Data_retail group by product_name,category
) AS t
WHERE t.row_number = 1


/*ANALYSIS-3
 Find the most reviewed product in each warehouse.*/
 
/* SOLUTION */
 	
select * from
(
select warehouse,product_name,sum(reviews)as total_review,row_number() over (partition by warehouse order by sum(reviews) desc)as row_num from Data_retail
group by warehouse,product_name
)as t
where t.row_num = 1


/*ANALYSIS-4
 find products that have higher-than-average prices within their category, along with their discount and supplier.*/
 
/* SOLUTION */
with cte as 
(select category,avg(price) as avg_price from Data_retail
group by category)

select dr.product_name,dr.category,dr.price,dr.discount,dr.supplier from Data_retail dr
inner join cte
on dr.category = cte.category
where dr.price > cte.avg_price
order by category


/*ANALYSIS-5
 Query to find the top 2 products with the highest average rating in each category.*/
 
/* SOLUTION */

select * from
(
select category,product_name,avg(rating)as avg_rating,row_number()over(partition by category order by avg(rating)desc)as row_num from Data_retail
group by category,product_name
) as t
where row_num < 3

/*ANALYSIS-6
 Analysis Across All Return Policy Categories(Count, Avgstock, total stock, weighted_avg_rating, etc.*/
 
/* SOLUTION */

select return_policy,count(return_policy)as count_products,avg(stock_quantity) as avg_stock,sum(stock_quantity)as total_stock from Data_retail
group by return_policy
order by avg(stock_quantity),sum(stock_quantity)