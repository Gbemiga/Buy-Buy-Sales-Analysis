/*
1. What is the total profit made by BuyBuy from 
1Q11 to 4Q16 (all quarters of every year)?
*/

SELECT SUM(revenue - cost) AS total_profit,
TO_CHAR(sales_date, '"Q"q:yyyy') AS quarter_sales
FROM sales_data
GROUP BY 2
ORDER BY 1 DESC;

/*
2. What is the total profit made by BuyBuy 
in Q2 of every year from 2011 to 2016?
*/

SELECT SUM(revenue - cost) AS total_profit,
Extract(year from sales_date) AS sales_year,
date_part('quarter', sales_date) AS sales_quarter
FROM sales_data
WHERE date_part('quarter', sales_date) = 2
and sales_date >= date '01-01-2011'
and sales_date < date '01-01-2017'
GROUP BY 2,3
ORDER BY 2 DESC;

/*
3. What is the annual profit made by 
BuyBuy from the year 2011 to 2016?
*/

SELECT SUM(revenue - cost) AS annual_profit,
EXTRACT(year from sales_date) AS sales_year
FROM sales_data
GROUP BY 2
ORDER BY 2 DESC;

/*
4. In which countries was BuyBuy made the most profit and 
   also the least profit of all-time?. 
   The query must display both results on the same output.
*/
ALTER TABLE sales_data
ADD profit INT;

UPDATE sales_data
set profit = (revenue - cost);

SELECT aa.countries, least_profit, b.countries,
most_profit, aa.sales_year
FROM
(SELECT ROW_NUMBER()OVER(ORDER BY SUM(profit)ASC) 
AS row_number,cus_country AS countries,
SUM(profit) AS least_profit,
EXTRACT(year from sales_date) AS sales_year
FROM sales_data
GROUP BY 2,4) aa
INNER JOIN
(SELECT ROW_NUMBER()OVER(ORDER BY SUM(profit)DESC) 
AS row_number,cus_country AS countries,
SUM(profit) AS most_profit,
EXTRACT(year from sales_date) AS sales_year
FROM sales_data
GROUP BY 2,4) b
ON aa.row_number = b.row_number

/*
5.What are the Top-10 most profitable countries for 
BuyBuy sales operations from 2011 to 2016?
*/

SELECT cus_country,
date_part('year', sales_date) AS sales_year,
SUM(profit) AS most_profit
FROM sales_data
WHERE date_part('year', sales_date) >= 2011
AND date_part('year', sales_date) < 2017
GROUP BY 1,2
ORDER BY 2 DESC, 3

/*
6. What are the all-time Top-10 least profitable 
countries for BuyBuy sales operations?
*/
SELECT distinct(cus_country),
EXTRACT(year from sales_date) AS sales_year,
SUM(profit) AS least_profit
FROM sales_data
GROUP BY 1,2
ORDER BY 3 ASC 
LIMIT 10;

/*
7. Rank all product categories sold by Buybuy, from least 
amount to the most amount of all-time revenue generated.
*/

SELECT prod_category, 
SUM(revenue),
EXTRACT(year from sales_date) AS sales_year,
DENSE_RANK() OVER(ORDER BY SUM(revenue)) AS dense_rank
FROM sales_data
GROUP BY 1,3
ORDER BY 2;

/*
8. What are the Top-2 product categories offered by 
Buybuy with an all-time high number of units sold?
*/

SELECT prod_category, 
SUM(ord_quantity) AS quantity_sold
FROM sales_data
GROUP BY 1
ORDER BY 2 DESC
LIMIT 2;

/*
9. What are the Top 10 highest-grossing products sold by 
BuyBuy based on all-time profits?
*/

SELECT prod_subcategory, 
SUM(profit)
FROM sales_data
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;