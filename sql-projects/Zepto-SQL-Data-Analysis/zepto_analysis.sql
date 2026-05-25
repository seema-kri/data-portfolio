drop table if exists zepto;
CREATE table zepto(
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuery INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,
quantity INTEGER
);

--data exploration
--count of rows
SELECT COUNT(*) FROM zepto;

--sample data
SELECT * FROM zepto
LIMIT 10;

--null values
SELECT * FROM ZEPTO
WHERE name IS NULL
OR
category IS NULL
OR
 mrp IS NULL
OR
discountpercent IS NULL
OR
discountedsellingprice IS NULL
OR
weightInGms IS NULL
OR
availableQuantity IS NULL
OR
outOfStock IS NULL
OR
quantity IS NULL;

--different product categories
SELECT DISTINCT category
FROM zepto
ORDER BY category;

-- product in stock vs out of stock
SELECT outOfStock, COUNT(sku_id)
FROM zepto
GROUP BY outOfStock;

--product names present multiple times
SELECT name, Count(sku_id) as "Number of SKUs"
FROM zepto
GROUP BY name
HAVING count(sku_id)>1
ORDER BY count(sku_id) DESC;

--data cleaning
--product with price=0
SELECT * FROM zepto
WHERE mrp=0 OR discountedSellingPrice=0;

DELETE FROM zepto
WHERE mrp=0;

--convert paise to rupees
UPDATE zepto
SET mrp=mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0;

SELECT mrp, discountedSellingPrice From zepto;

-- Q1.Find the top 10 best- value product based on the discount percentage.
SELECT DISTINCT name, mrp,discountPercent 
FROM zepto
ORDER BY discountPercent Desc
LIMIT 10;

--Q2.what are the products with high mrp but out of stock
SELECT DISTINCT name , mrp
FROM zepto
WHERE outOfStock= TRUE and mrp>300
ORDER BY mrp DESC;

--Q3.Calculate Estimated revenue for each category
SELECT category,
SUM(discountedSellingPrice*availableQuantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue;

--Q4.Find all the products where MRP is greater than 500 and discount is less than 10%.
SELECT DISTINCT name, mrp, discountPercent
FROM zepto
WHERE mrp>500 AND discountPercent<10
ORDER BY mrp Desc, discountPercent DESC;

--Q5.Identify the top 5 categories offering the highest average discount perecentage.
SELECT category,
ROUND(AVG(discountPercent),2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

--Q6.Find the price per gram for products above 100g and sort by best value.
SELECT DISTINCT name, weightInGms,discountedSellingPrice,
ROUND(discountedSellingPrice/weightInGms,2) AS price_per_gram
FROM zepto
WHERE weightIngms>=100
ORDER BY price_per_gram;

--Q7.Group the products into categories like low , medium, bulk.
SELECT DISTINCT name, weightInGms,
CASE WHEN weightINGms<1000 THEN 'Low'
	WHEN weightINGms<5000 THEN 'Medium'
	ELSE 'Bulk'
	END AS weight_category
FROM zepto;

--Q8.What is the total investory weight per category
SELECT category,
SUM(weightInGms*availableQuantity)AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;
