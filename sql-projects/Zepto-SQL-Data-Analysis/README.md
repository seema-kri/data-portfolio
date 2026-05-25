# 📦 Zepto Data Analysis – SQL Business Insights Project

## 📌 Project Overview
This project is my **first end-to-end SQL data analysis project**, built using a realistic dataset inspired by **Zepto**, a quick-commerce grocery delivery platform.

The purpose of this project is to use **SQL** to extract meaningful **business insights** related to **pricing strategy, discounts, inventory distribution, and product performance**.  
It demonstrates my ability to think like a data analyst and translate raw product data into actionable insights.

---

## 🎯 Project Objective
- Analyze product-level data using SQL
- Understand pricing and discount strategies
- Identify inventory and stock patterns
- Generate insights useful for **business, operations, and supply chain teams**

---

## 🗂 Dataset Description
The dataset contains product-level details commonly found in quick-commerce platforms.

### Columns Included
- `sku_id`
- `category`
- `name`
- `mrp`
- `quantity`
- `discountPercent`
- `availableQuantity`
- `discountedSellingPrice`
- `weightInGms`
- `outOfStock`

---

## ⚙️ Data Analysis Workflow

### 1️⃣ Data Setup
- Created a SQL table to store product data
- Defined appropriate data types for prices, quantities, and weights

### 2️⃣ Data Exploration
- Checked table structure and data distribution
- Counted products by category
- Identified missing, duplicate, and invalid values

### 3️⃣ Data Cleaning
- Removed products with `MRP = 0`
- Converted prices from **paise to rupees**
- Handled NULL values and removed duplicates

### 4️⃣ SQL Analysis
Performed analysis using SQL queries to answer business questions such as:
- Top 10 products offering the **highest discounts**
- High-MRP products that are **out of stock**
- **Estimated revenue** by category
- Categories with the **highest average discounts**
- **Price per gram** comparison across products
- Product grouping by **weight categories** (Low / Medium / Bulk)
- Total **inventory weight by category**

📄 **Main SQL File:**  
➡️ [View zepto_analysis.sql](./zepto_analysis.sql)

---

## 📊 Key Business Insights

### 🛒 Discount Strategy
- Fruits & Vegetables and Meats, Fish & Eggs receive higher discounts due to perishability
- Premium and essential items maintain lower discounts to protect margins

### 💰 Revenue Trends
- Cooking Essentials, Munchies, and Personal Care generate the **highest estimated revenue**
- Fresh produce contributes lower revenue but drives customer engagement

### ⚖️ Inventory Distribution
- Cooking Essentials and Munchies dominate total inventory weight
- Meats, Fish & Eggs are lighter, aiding faster delivery and storage efficiency

### ⚡ Best Value Products
- Staples like **salt and onions** have the lowest price per gram
- These items provide strong value for customers

### 📦 Weight-Based Patterns
- Majority of products fall under **light-weight (<1000g)** category
- Supports Zepto’s quick-delivery operational model

---

## 📁 Project Files
| File | Description |
|-----|------------|
| [`zepto_analysis.sql`](./zepto_analysis.sql) | Main SQL script with all analysis queries |
| [`Zepto_Business_Insights.pdf`](./Zepto_Business_Insights.pdf) | Visual presentation of insights |

---

## 💡 Key Learnings
- Writing practical SQL queries using:
  - `SELECT`, `WHERE`, `GROUP BY`, `ORDER BY`, `CASE`
- Cleaning and preparing real-world-style datasets
- Using `SUM`, `AVG`, `COUNT` for business analysis
- Thinking analytically and asking **impactful business questions**
- Presenting insights clearly and logically

---

## 🚀 Future Improvements
- Add customer-level analysis
- Include profit and margin calculations
- Automate insights using views or stored procedures
- Visualize insights using Power BI

---

## 👩‍💻 About Me
Hi, I’m **Seema Kumari**, an aspiring **Data Analyst** passionate about turning raw data into meaningful business insights.  
I am actively building projects in **SQL, Excel, Power BI, and Python** to strengthen my analytics skills and prepare for real-world roles.

[![Email](https://img.shields.io/badge/Email-red?logo=gmail&logoColor=white)](mailto:kriseema87@gmail.com)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-blue?logo=linkedin)](https://www.linkedin.com/in/seema-kumari-375763308/)
[![GitHub](https://img.shields.io/badge/GitHub-black?logo=github)](https://github.com/seema-kri)


⭐ *Thank you for exploring this project!*  
This project represents my learning journey in SQL and my readiness to grow as a data analyst.
---

⭐ *Thank you for exploring this project!*  
This project represents my learning journey in SQL and my readiness to grow as a data analyst.

