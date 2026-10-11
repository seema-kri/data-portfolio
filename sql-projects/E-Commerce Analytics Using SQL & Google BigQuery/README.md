
# E-Commerce Analytics Using SQL & Google BigQuery

Analyzing e-commerce sales trends, customer behavior, payment patterns, freight costs, and delivery performance using SQL and Google BigQuery to generate actionable business insights.

**Dataset:** [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

**Project Context:** This project is an independent e-commerce analytics case study using the publicly available Brazilian E-Commerce Dataset by Olist.

---

## Table of Contents

- [Project Overview](#project-overview)
- [Business Problem](#business-problem)
- [Project Objectives](#project-objectives)
- [Dataset Description](#dataset-description)
- [Tools and Technologies](#tools-and-technologies)
- [SQL Skills Demonstrated](#sql-skills-demonstrated)
- [Project Structure](#project-structure)
- [Data Preparation](#data-preparation)
- [Analysis and Key Insights](#analysis-and-key-insights)
- [SQL Queries and Examples](#sql-queries-and-examples)
- [Business Recommendations](#business-recommendations)
- [How to Run the Project](#how-to-run-the-project)
- [Limitations and Future Improvements](#limitations-and-future-improvements)
- [Author](#author)

---

## Project Overview

This project analyzes a Brazilian e-commerce marketplace dataset containing approximately 100,000 orders placed between September 2016 and October 2018.

Using SQL in Google BigQuery, I explored order trends, customer distribution, payment behavior, freight costs, and delivery performance to identify patterns and generate actionable business insights.

The project demonstrates how SQL can transform raw relational data into meaningful insights that support business analysis and data-driven decision-making.

## Business Problem

E-commerce businesses need to understand customer purchasing patterns, shipping expenses, payment preferences, and delivery efficiency to improve customer satisfaction and operational performance.

This project addresses the following business questions:

- How does order volume change across months and years?
- Which Brazilian states have the highest customer concentration?
- How did total payment value change between January–August 2017 and January–August 2018?
- Which states have the highest and lowest average freight costs?
- Which states experience the longest and shortest delivery times?
- Which states deliver orders earlier than estimated?
- Which payment methods and installment plans are most frequently used?

## Project Objectives

- Analyze monthly and yearly order trends.
- Identify peak purchasing hours and seasonal patterns.
- Examine customer distribution across Brazilian states.
- Measure payment value growth between comparable periods.
- Compare product prices and freight charges across states.
- Evaluate actual delivery times against estimated delivery dates.
- Analyze payment methods and installment usage.
- Translate SQL results into actionable business recommendations.

## Dataset Description

The project uses the **Brazilian E-Commerce Public Dataset by Olist**, available on Kaggle.

**Dataset source:** [Brazilian E-Commerce Public Dataset by Olist — Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

The dataset contains eight related tables:

| Table | Description |
|---|---|
| `customers` | Customer identifiers, cities, states, and postal codes |
| `orders` | Order status and purchase/delivery timestamps |
| `order_items` | Products purchased, prices, and freight charges |
| `payments` | Payment types, payment values, and installments |
| `order_reviews` | Customer ratings and review comments |
| `products` | Product categories, dimensions, and weight |
| `sellers` | Seller identifiers and geographic information |
| `geolocation` | Geographic coordinates, cities, and states |

**Dataset period:** September 2016 – October 2018.

## Tools and Technologies

- **SQL:** Data querying and analysis
- **Google BigQuery:** Cloud data warehouse and SQL execution
- **GitHub:** Project version control and documentation

## SQL Skills Demonstrated

- Data exploration and schema inspection
- Filtering with `WHERE`
- Sorting with `ORDER BY`
- Aggregation using `SUM()`, `AVG()`, and `COUNT()`
- Multi-table joins using `INNER JOIN`
- Grouping using `GROUP BY`
- Date analysis using `EXTRACT()` and `DATE_DIFF()`
- Common Table Expressions (CTEs)
- Window functions such as `LEAD()`
- Conditional aggregation using `IF()`
- Percentage calculations using `SAFE_DIVIDE()`
- Distinct counting using `COUNT(DISTINCT ...)`
- Translating query results into business insights

## Project Structure

```text
ecommerce-sql-analytics/
│
├── README.md
├── ecommerce_analysis.sql
└── screenshots/
    └── query_results.png
```

## Data Preparation

The analysis was performed using Google BigQuery and the eight relational tables.

Key preparation and validation steps included:

- Previewing tables to understand their structure and sample records.
- Inspecting column names and data types.
- Joining related tables using customer and order identifiers.
- Filtering purchase timestamps for specific comparison periods.
- Excluding undelivered orders from completed-delivery calculations.
- Using distinct order counts where multiple payment records could otherwise affect counts.
- Calculating delivery duration and differences between actual and estimated delivery dates.

SQL was used for data preparation and analysis. No separate Python-based data-cleaning pipeline was used in this project.

## Analysis and Key Insights

### 1. Order Trends and Seasonality

Analyzed monthly order volume and order activity by hour to understand purchasing patterns.

- August recorded the highest order count in the combined monthly analysis, with **10,843 orders**.
- Monthly and hourly analyses help identify periods of relatively high purchasing activity.

*The monthly result combines all years, so it shows total order volume by calendar month rather than year-over-year growth.*

### 2. Customer Geographic Distribution

Analyzed customer counts across Brazilian cities and states to understand geographic demand.

- Compared customer concentration across locations.
- Identified regions that may warrant further investigation for marketing and service planning.

### 3. Payment Value Growth

Compared total payment value from January–August 2017 with January–August 2018.

- **Observed payment value growth: approximately 136.98%.**

This indicates that the total recorded payment value was substantially higher during the comparable eight-month period in 2018.

*Payment value is not the same as profit, and this comparison alone does not establish the reasons for the increase.*

### 4. Freight Cost Analysis

Compared average and total freight charges across customer states.

- Examined geographic differences in average freight costs.
- Identified locations that may warrant further investigation into shipping expenses.

### 5. Delivery Performance

Calculated delivery duration using purchase and actual delivery timestamps, then compared actual delivery dates with estimated delivery dates.

- Identified states with longer average delivery times.
- Compared states delivering earlier or later than their estimated delivery dates.
- Used delivery metrics to identify potential logistics improvement areas.

### 6. Payment Behavior

Analyzed monthly order counts by payment type and grouped orders by the number of payment installments.

- Examined changes in payment method usage over time.
- Investigated customer preferences for single versus multiple installments.

*Add detailed state rankings and payment breakdowns after verifying your final query results.*

## SQL Queries and Examples

### 1. Monthly Order Trends

Identify monthly order volumes across years.

```sql
SELECT
    EXTRACT(YEAR FROM order_purchase_timestamp) AS year,
    EXTRACT(MONTH FROM order_purchase_timestamp) AS month,
    COUNT(DISTINCT order_id) AS total_orders
FROM `TARGETSQL.orders`
GROUP BY year, month
ORDER BY year, month;
```

**SQL concepts:** Date extraction, aggregation, grouping, and sorting.

### 2. Customer Distribution by State

Identify states with the highest number of customers.

```sql
SELECT
    customer_state,
    COUNT(DISTINCT customer_id) AS total_customers
FROM `TARGETSQL.customers`
GROUP BY customer_state
ORDER BY total_customers DESC;
```

**SQL concepts:** `COUNT(DISTINCT)`, `GROUP BY`, and `ORDER BY`.

### 3. Top Five States by Average Freight Value

Compare average freight charges across customer states.

```sql
SELECT
    c.customer_state,
    ROUND(AVG(oi.freight_value), 2) AS avg_freight_value
FROM `TARGETSQL.orders` AS o
JOIN `TARGETSQL.customers` AS c
    ON o.customer_id = c.customer_id
JOIN `TARGETSQL.order_items` AS oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_state
ORDER BY avg_freight_value DESC
LIMIT 5;
```

**SQL concepts:** Multiple-table joins, aggregate functions, sorting, and limiting results.

### 4. Delivery Performance Analysis

Calculate delivery duration and compare actual delivery dates with estimated dates.

```sql
SELECT
    order_id,
    DATE_DIFF(
        DATE(order_delivered_customer_date),
        DATE(order_purchase_timestamp),
        DAY
    ) AS delivery_days,
    DATE_DIFF(
        DATE(order_delivered_customer_date),
        DATE(order_estimated_delivery_date),
        DAY
    ) AS days_vs_estimate
FROM `TARGETSQL.orders`
WHERE order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL;
```

**Interpretation:** Negative `days_vs_estimate` values indicate early delivery; positive values indicate late delivery.

**SQL concepts:** Date calculations, filtering, and derived columns.

### 5. Payment Value Growth Using a CTE

Calculate the percentage increase in payment value from January–August 2017 to January–August 2018.

```sql
WITH yearly_totals AS (
    SELECT
        EXTRACT(YEAR FROM o.order_purchase_timestamp) AS year,
        SUM(p.payment_value) AS total_payment
    FROM `TARGETSQL.payments` AS p
    JOIN `TARGETSQL.orders` AS o
        ON p.order_id = o.order_id
    WHERE EXTRACT(YEAR FROM o.order_purchase_timestamp)
          IN (2017, 2018)
      AND EXTRACT(MONTH FROM o.order_purchase_timestamp)
          BETWEEN 1 AND 8
    GROUP BY year
)
SELECT
    MAX(IF(year = 2017, total_payment, NULL)) AS payment_2017,
    MAX(IF(year = 2018, total_payment, NULL)) AS payment_2018,
    ROUND(
        SAFE_DIVIDE(
            MAX(IF(year = 2018, total_payment, NULL))
            - MAX(IF(year = 2017, total_payment, NULL)),
            MAX(IF(year = 2017, total_payment, NULL))
        ) * 100,
        2
    ) AS percentage_increase
FROM yearly_totals;
```

**SQL concepts:** CTEs, conditional aggregation, `SAFE_DIVIDE()`, and percentage calculations.

**Finding:** Total payment value increased by approximately **136.98%** between the two comparable periods.

## Business Recommendations

Based on the analyses, the following areas deserve further investigation:

- **Optimize logistics:** Investigate states with higher average freight costs and longer delivery times.
- **Improve delivery reliability:** Monitor differences between estimated and actual delivery dates to improve delivery estimates and customer communication.
- **Plan for demand:** Use monthly and hourly order patterns to inform staffing and fulfillment planning.
- **Understand payment preferences:** Use payment method and installment trends to evaluate the payment experience.
- **Explore regional opportunities:** Use customer distribution data to identify areas for targeted marketing and service improvements.

These recommendations are potential actions for further business evaluation; the analysis does not independently prove that any single factor causes a business outcome.

## How to Run the Project

1. Clone or download this GitHub repository.
2. Open [Google BigQuery](https://console.cloud.google.com/bigquery).
3. Create or select a Google Cloud project and create a dataset.
4. Upload the eight CSV files to BigQuery, using the expected table and column names.
5. Open the SQL script in the BigQuery SQL editor.
6. Update table references to match your project and dataset names.
7. Run the queries individually or in logical sections.
8. Review the results and validate the findings before drawing business conclusions.

**Important:** The example queries use `TARGETSQL` as the dataset name. Replace it with your actual dataset name if it differs.

## Limitations and Future Improvements

### Limitations

- The dataset covers historical transactions from 2016–2018 and does not reflect current market conditions.
- Payment value does not represent profit or net revenue.
- Geographic averages may hide differences in order size, product mix, and distance.
- The analysis identifies patterns but does not establish causation.

### Future Improvements

- Build an interactive Power BI dashboard to present the main findings.
- Add data quality checks for missing values, duplicates, and inconsistent timestamps.
- Explore customer segmentation and repeat-purchase behavior.
- Investigate factors associated with delayed deliveries.
- Develop predictive models for delivery duration or customer purchasing behavior.

## Author

**Seema Kumari**  
Data Analyst | Machine Learning Enthusiast

- **GitHub:** [@seema-kri](https://github.com/seema-kri)
- **LinkedIn:** [seema-kumari-375763308](https://linkedin.com/in/seema-kumari-375763308)

---

If you find this project useful, feel free to explore the SQL queries and analysis.
