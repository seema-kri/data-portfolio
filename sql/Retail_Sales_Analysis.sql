
CREATE TABLE retail_sales_stage (
    order_id VARCHAR,
    customer_id VARCHAR,
    customer_segment VARCHAR,
    age_group VARCHAR,
    age INT,
    month VARCHAR,
    order_date VARCHAR,      -- keep VARCHAR for safety
    order_status VARCHAR,
    sales_channel VARCHAR,
    sku VARCHAR,
    product_category VARCHAR,
    size VARCHAR,
    quantity INT,
    order_amount NUMERIC(10,2),
    ship_city VARCHAR,
    ship_state VARCHAR,
    ship_postal_code VARCHAR,
    ship_country VARCHAR,
    b2b_flag VARCHAR
);




SELECT * FROM retail_sales_stage;

-- 1. Total Orders & Sales (Simple but effective)
SELECT 
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(order_amount) AS total_sales,
    ROUND(AVG(order_amount), 2) AS avg_order_value
FROM retail_sales_stage;

-- 2. Sales by Gender (Simple logic)
SELECT 
    CASE 
        WHEN customer_segment LIKE '%Men%' OR age_group LIKE '%Male%' THEN 'Men'
        WHEN customer_segment LIKE '%Women%' OR age_group LIKE '%Female%' THEN 'Women'
        ELSE 'Unknown'
    END AS gender,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(order_amount) AS total_sales,
    ROUND(SUM(order_amount) * 100.0 / 
        (SELECT SUM(order_amount) FROM retail_sales_stage), 2) AS sales_percentage
FROM retail_sales_stage
GROUP BY 
    CASE 
        WHEN customer_segment LIKE '%Men%' OR age_group LIKE '%Male%' THEN 'Men'
        WHEN customer_segment LIKE '%Women%' OR age_group LIKE '%Female%' THEN 'Women'
        ELSE 'Unknown'
    END;

-- 3. Monthly Sales Trend (Jan-May)
SELECT 
    month,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(order_amount) AS total_sales,
    ROUND(SUM(order_amount) * 100.0 / 
        (SELECT SUM(order_amount) FROM retail_sales_stage WHERE month IN ('Jan','Feb','Mar','Apr','May')), 2)
		AS monthly_percentage
FROM retail_sales_stage
WHERE month IN ('Jan', 'Feb', 'Mar', 'Apr', 'May')
GROUP BY month
ORDER BY 
    CASE month
        WHEN 'Jan' THEN 1
        WHEN 'Feb' THEN 2
        WHEN 'Mar' THEN 3
        WHEN 'Apr' THEN 4
        WHEN 'May' THEN 5
        ELSE 6
    END;
-- 4. Order Status Summary
SELECT 
    order_status,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(order_amount) AS total_amount,
    ROUND(COUNT(DISTINCT order_id) * 100.0 / 
        (SELECT COUNT(DISTINCT order_id) FROM retail_sales_stage), 2) 
		AS order_percentage
FROM retail_sales_stage
WHERE order_status IN ('Delivered', 'Refunded', 'Returned', 'Cancelled')
GROUP BY order_status
ORDER BY total_orders DESC;

-- 5. Top 5 States by Sales
SELECT 
    ship_state,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(order_amount) AS total_sales,
    ROUND(SUM(order_amount) * 100.0 / 
        (SELECT SUM(order_amount) FROM retail_sales_stage 
		WHERE ship_state IS NOT NULL), 2) AS sales_percentage
FROM retail_sales_stage
WHERE ship_state IS NOT NULL
GROUP BY ship_state
ORDER BY total_sales DESC
LIMIT 5;

-- 6. Channel-wise Performance
SELECT 
    sales_channel,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(order_amount) AS total_sales,
    ROUND(AVG(order_amount), 2) AS avg_order_value,
    ROUND(SUM(order_amount) * 100.0 / 
        (SELECT SUM(order_amount) FROM retail_sales_stage
		WHERE sales_channel IN ('Flipkart','Meesho','Myntra','Nalli','Others')), 2)
		AS channel_percentage
FROM retail_sales_stage
WHERE sales_channel IN ('Flipkart', 'Meesho', 'Myntra', 'Nalli', 'Others')
GROUP BY sales_channel
ORDER BY total_sales DESC;

-- 7. Product Category Performance
SELECT 
    product_category,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(order_amount) AS total_sales,
    SUM(quantity) AS total_units_sold,
    ROUND(AVG(order_amount), 2) AS avg_order_value
FROM retail_sales_stage
WHERE product_category IN ('Blouse', 'Bottom', 'Ethnic Dress', 'Kurta', 'Saree', 'Set')
GROUP BY product_category
ORDER BY total_sales DESC;

-- 8. Orders by Age Group
SELECT 
    age_group,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(order_amount) AS total_sales,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales_stage
WHERE age_group IS NOT NULL
GROUP BY age_group
ORDER BY total_orders DESC;

-- 9. What do Men vs Women buy? (Business Insight)
SELECT 
    CASE 
        WHEN customer_segment LIKE '%Men%' OR age_group LIKE '%Male%' THEN 'Men'
        WHEN customer_segment LIKE '%Women%' OR age_group LIKE '%Female%' THEN 'Women'
        ELSE 'Unknown'
    END AS gender,
    product_category,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(order_amount) AS total_sales
FROM retail_sales_stage
WHERE product_category IN ('Blouse', 'Bottom', 'Ethnic Dress', 'Kurta', 'Saree', 'Set')
GROUP BY 
    CASE 
        WHEN customer_segment LIKE '%Men%' OR age_group LIKE '%Male%' THEN 'Men'
        WHEN customer_segment LIKE '%Women%' OR age_group LIKE '%Female%' THEN 'Women'
        ELSE 'Unknown'
    END,
    product_category
ORDER BY gender, total_sales DESC;

-- 10. Which channel delivers best?
SELECT 
    sales_channel,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(CASE WHEN order_status = 'Delivered' THEN 1 ELSE 0 END) AS
	delivered_orders,
    ROUND(
        SUM(CASE WHEN order_status = 'Delivered' THEN 1 ELSE 0 END) * 100.0 / 
        COUNT(DISTINCT order_id), 
        2
    ) AS delivery_rate
FROM retail_sales_stage
WHERE sales_channel IN ('Flipkart', 'Meesho', 'Myntra', 'Nalli', 'Others')
GROUP BY sales_channel
ORDER BY delivery_rate DESC;

--11. Using CTE to calculate Month-over-Month (MoM) Growth
WITH monthly_data AS (
    SELECT month, SUM(order_amount) AS monthly_sales
    FROM retail_sales_stage
    WHERE month IN ('Jan','Feb','Mar','Apr','May')
    GROUP BY month
)
SELECT 
    m1.month,
    m1.monthly_sales,
    COALESCE(m2.monthly_sales, 0) AS previous_month_sales,
    ROUND((m1.monthly_sales - COALESCE(m2.monthly_sales, 0)) * 100.0 / 
          NULLIF(COALESCE(m2.monthly_sales, 0), 0), 2) AS growth_pct
FROM monthly_data m1
LEFT JOIN monthly_data m2 ON m1.month = 
    CASE m2.month WHEN 'Jan' THEN 'Feb' WHEN 'Feb' THEN 'Mar' 
                  WHEN 'Mar' THEN 'Apr' WHEN 'Apr' THEN 'May' END
ORDER BY m1.monthly_sales DESC;

--12. Identifying High-Value States via Average Order Value (AOV)
SELECT 
    ship_state,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(order_amount) AS total_sales,
    ROUND(SUM(order_amount) / COUNT(DISTINCT order_id), 2) AS avg_order_value
FROM retail_sales_stage
WHERE ship_state IS NOT NULL
GROUP BY ship_state
HAVING COUNT(DISTINCT order_id) > 10
ORDER BY avg_order_value DESC
LIMIT 5;

--13. Ranking Product Categories per Sales Channel using Window Functions
SELECT sales_channel, product_category, total_sales
FROM (
    SELECT 
        sales_channel,
        product_category,
        SUM(order_amount) AS total_sales,
        ROW_NUMBER() OVER (PARTITION BY sales_channel
		ORDER BY SUM(order_amount) DESC) AS rank
    FROM retail_sales_stage
    GROUP BY sales_channel, product_category
) ranked
WHERE rank = 1;

