--1. Preview all 8 tables (EDA)
SELECT * FROM `TARGETSQL.order_items` LIMIT 10;

SELECT * FROM `TARGETSQL.order_reviews` LIMIT 10;

SELECT * FROM `TARGETSQL.orders` LIMIT 10;

SELECT * FROM `TARGETSQL.payments` LIMIT 10;

SELECT * FROM `TARGETSQL.products` LIMIT 10;

SELECT * FROM `TARGETSQL.sellers` LIMIT 10;

--3. Find the time range between which orders were placed
SELECT
  MIN(order_purchase_timestamp) AS start_time,
  MAX(order_purchase_timestamp) AS end_date
FROM `TARGETSQL.orders`;
-- Insight: Orders were placed between September 2016 and October 2018.

--4. Count cities and states of customers who ordered during the period
SELECT
  COUNT(DISTINCT c.customer_city) AS total_cities,
  COUNT(DISTINCT c.customer_state) AS total_states
FROM `TARGETSQL.orders` AS o
JOIN `TARGETSQL.customers` AS c
  ON o.customer_id = c.customer_id
WHERE EXTRACT(YEAR FROM o.order_purchase_timestamp) = 2018
  AND EXTRACT(MONTH FROM o.order_purchase_timestamp)
      BETWEEN 1 AND 3;

--5. Is there a growing trend in the number of orders?
SELECT
  EXTRACT(MONTH FROM order_purchase_timestamp) AS month,
  COUNT(order_id) AS order_numbers
FROM `TARGETSQL.orders`
GROUP BY month
ORDER BY order_numbers DESC;
-- Insight: August recorded the highest number of orders (10,843), followed by May (10,573) and July (10,318).

--6. During what time of day do Brazilian customers mostly order?
SELECT
  EXTRACT(HOUR FROM order_purchase_timestamp) AS time,
  COUNT(order_id) AS order_numbers
FROM `TARGETSQL.orders`
GROUP BY time
ORDER BY order_numbers DESC;
-- Insight: Brazilian customers place the highest number of orders during the afternoon (13:00–18:00).


--7. Distribution of customers across Brazilian states and cities
SELECT
  customer_city,
  customer_state,
  COUNT(DISTINCT customer_id) AS customer_count
FROM `TARGETSQL.customers`
GROUP BY customer_city, customer_state
ORDER BY customer_count DESC;
-- Insight: São Paulo (SP) has the highest customer count (15,540), while Duque de Caxias (RJ) has the lowest (266) among the cities returned by this query.

--8.Get the % increase in the cost of orders from year 2017 to 2018 (include months between Jan to Aug only).
--You can use the "payment_value" column in the payments table to get the cost of orders.
with yearly_totals as(
select 
extract(year from o.order_purchase_timestamp) as year,
sum(p.payment_value) as total_payment
from `TARGETSQL.payments` as p
join `TARGETSQL.orders` as o
on p.order_id=o.order_id
where extract(year from o.order_purchase_timestamp) in (2017,2018)
and extract(month from o.order_purchase_timestamp) between 1 and 8
group by extract(year from o.order_purchase_timestamp)),

yearly_comparison as(
select year,total_payment,lead(total_payment) over(order by year desc) as prev_year_payment
from yearly_totals)

select year,((round(total_payment-prev_year_payment)/prev_year_payment)*100,2)
from yearly_comparison
--Payment value increased by approximately 136.98% from January–August 2017 to January–August 2018, indicating substantial growth in the total value of customer payments during the comparable eight-month period.

--9.mean and sum of price & frieght value by customer state
select c.customer_state,
avg(price) as avg_price,
sum(price) as sum_price,
avg(freight_value) as avg_freight,
sum(freight_value) as sum_freight
from `TARGETSQL.orders` as o
join `TARGETSQL.order_items` as o1
on o.order_id=o1.order_id
join `TARGETSQL.customers` as c
on o.customer_id=c.customer_id
group by c.customer_state

--10.Calculate days between purchasing,delivering and estimated delivery.
select order_id,
date_diff(date(order_delivered_customer_date),date(order_purchase_timestamp),day) as days_to_delivery,
date_diff(date(order_delivered_customer_date),date(order_estimated_delivery_date),day) as diff_estimated_delivery
from `TARGETSQL.orders`

--11.Find out the top 5 states with the highest & lowest average freight value

select c.customer_state,
avg(freight_value) as avg_freight_value
from `TARGETSQL.orders` as o
join `TARGETSQL.order_items` as o1
on o.order_id=o1.order_id
join `TARGETSQL.customers` as c
on o.customer_id=c.customer_id
group by customer_state
order by avg_freight_value desc
limit 5


select c.customer_state,
avg(freight_value) as avg_freight_value
from `TARGETSQL.orders` as o
join `TARGETSQL.order_items` as o1
on o.order_id=o1.order_id
join `TARGETSQL.customers` as c
on o.customer_id=c.customer_id
group by customer_state
order by avg_freight_value asc
limit 5


--12.Find out the top 5 states with the highest & lowest average delivery time
--Highest average delivery time
select c.customer_state,
avg(extract(date from o.order_delivered_customer_date)-extract(date from o.order_purchase_timestamp)) as avg_time_to_delivery
from `TARGETSQL.orders` as o
join `TARGETSQL.order_items` as o1
on o.order_id=o1.order_id
join `TARGETSQL.customers` as c
on o.customer_id=c.customer_id
group by customer_state
order by avg_time_to_delivery desc
limit 5

--Lowest average delivery time
select c.customer_state,
avg(extract(date from o.order_delivered_customer_date)-extract(date from o.order_purchase_timestamp)) as avg_time_to_delivery
from `TARGETSQL.orders` as o
join `TARGETSQL.order_items` as o1
on o.order_id=o1.order_id
join `TARGETSQL.customers` as c
on o.customer_id=c.customer_id
group by customer_state
order by avg_time_to_delivery asc
limit 5

--13.Top 5 states where delivery is fastest compared with the estimated delivery date
SELECT
  c.customer_state,
  ROUND(AVG(DATE_DIFF(
    DATE(o.order_estimated_delivery_date),
    DATE(o.order_delivered_customer_date),
    DAY
  )), 2) AS avg_days_early
FROM `TARGETSQL.orders` AS o
JOIN `TARGETSQL.customers` AS c
  ON o.customer_id = c.customer_id
WHERE o.order_delivered_customer_date IS NOT NULL
  AND o.order_estimated_delivery_date IS NOT NULL
GROUP BY c.customer_state
ORDER BY avg_days_early DESC
LIMIT 5;

--14.Find the month on month no. of orders placed using different payment types
SELECT
  EXTRACT(YEAR FROM o.order_purchase_timestamp) AS year,
  EXTRACT(MONTH FROM o.order_purchase_timestamp) AS month,
  p.payment_type,
  COUNT(DISTINCT o.order_id) AS total_orders
FROM `TARGETSQL.orders` AS o
JOIN `TARGETSQL.payments` AS p
  ON o.order_id = p.order_id
GROUP BY year, month, p.payment_type
ORDER BY year, month, p.payment_type;

--15.Find the no. of orders placed on the basis of the payment installments that have been paid.
SELECT
  payment_installments,
  COUNT(DISTINCT order_id) AS total_orders
FROM `TARGETSQL.payments`
GROUP BY payment_installments
ORDER BY payment_installments;

