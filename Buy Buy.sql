SELECT sales_date,
TO_CHAR(sales_date, '"Q"q:yyyy') AS quarter_sales
FROM sales_data
ORDER by 2 DESC;

SELECT *
FROM sales_data;

--Q1--

--1a--
SELECT SUM(revenue - cost) AS profit,
TO_CHAR(sales_date, '"Q"q:yyyy') AS quarter_sales
FROM sales_data
GROUP BY 2
ORDER BY 1 DESC;

SELECT NOW():: time;
SELECT TO_CHAR(NOW():: date, 'dd/mm/yyyy')

--1b--

SELECT SUM(revenue - cost) AS profit,
Extract(year from sales_date) AS sales_year,
date_part('quarter', sales_date) AS sales_quarter
FROM sales_data
WHERE date_part('quarter', sales_date) = 2
and sales_date >= date '01-01-2011'
and sales_date < date '01-01-2017'
GROUP BY 2,3
ORDER BY 2 DESC;

/*SELECT Extract(Quarter from sales_date)
FROM sales_data;*/

--1c--
SELECT SUM(revenue - cost) AS profit,
EXTRACT(year from sales_date) AS sales_year
FROM sales_data
GROUP BY 2
ORDER BY 2 DESC;

--Q2--
SELECT distinct(cus_country), sales_year,profit,
MIN(profit) AS least_profit, 
MAX(profit) AS most_profit 
FROM (SELECT distinct(cus_country),
EXTRACT(year from sales_date) AS sales_year,
SUM(revenue - cost) AS profit
FROM sales_data
GROUP BY 1,2
ORDER BY 3 ASC, 1) AS aa
GROUP BY 1,2,3
ORDER BY 2 DESC;

--2b--

SELECT distinct(cus_country),
EXTRACT(year from sales_date) AS sales_year,
SUM(revenue - cost) AS most_profit
FROM sales_data
GROUP BY 1,2
ORDER BY 3 DESC 
LIMIT 10;

--2c--
SELECT distinct(cus_country),
EXTRACT(year from sales_date) AS sales_year,
SUM(revenue - cost) AS least_profit
FROM sales_data
GROUP BY 1,2
ORDER BY 3 ASC 
LIMIT 10;

--3a--

SELECT prod_category, 
SUM(revenue),
EXTRACT(year from sales_date) AS sales_year,
DENSE_RANK() OVER(ORDER BY SUM(revenue)) AS dense_rank
FROM sales_data
GROUP BY 1,3
ORDER BY 2;

--3b--

SELECT prod_category, 
SUM(ord_quantity) AS quantity_sold
FROM sales_data
GROUP BY 1
ORDER BY 2 DESC
LIMIT 2;

--3c--

SELECT prod_subcategory, 
SUM(revenue-cost) AS profit
FROM sales_data
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;